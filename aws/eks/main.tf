# From https://docs.aws.amazon.com/eks/latest/userguide/getting-started.html#eks-prereqs

locals {
  default_tags = {
    Name = "${var.name}"
  }

  tags = "${merge(default_tags, var.tags)}"
}

module "eks-vpc" {
  source = "../vpc"
  tags   = "${local.tags}"
}

module "eks-subnets" {
  source = "../vpc/subnets"

  internet_gateway_id = "${module.eks-vpc.internet_gateway_id}"
  tags                = "${local.tags}"
  vpc_id              = "${module.eks-vpc.vpc_id}"
}

resource "aws_iam_role" "eks_service_role" {
  name = "${var.name}"

  assume_role_policy = <<-EOF
    {
      "Version":"2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Principal": {
            "Service":"eks.amazonaws.com"
          },
          "Action": "sts:AssumeRole"
        }
      ]
    }
    EOF

  tags = "${local.tags}"
}

resource "aws_iam_role_policy_attachment" "eks_service_role_cluster_policy" {
  role       = "${aws_iam_role.eks_service_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "eks_service_role_service_policy" {
  role       = "${aws_iam_role.eks_service_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
}

resource "aws_security_group" "master" {
  name   = "${var.name}"
  tags   = "${local.tags}"
  vpc_id = "${module.eks-vpc.vpc_id}"
}

resource "aws_security_group_rule" "master_egress" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  protocol          = "-1"
  security_group_id = "${aws_security_group.master.id}"
  to_port           = 0
  type              = "egress"
}

resource "aws_eks_cluster" "master" {
  name     = "${var.name}"
  role_arn = "${aws_iam_role.eks_service_role.arn}"

  vpc_config {
    security_group_ids = ["${aws_security_group.master.id}"]

    subnet_ids = [
      "${lookup(module.eks-subnets.subnets_by_az, "us-east-1b")}",
      "${lookup(module.eks-subnets.subnets_by_az, "us-east-1c")}",
      "${lookup(module.eks-subnets.subnets_by_az, "us-east-1d")}",
      "${lookup(module.eks-subnets.subnets_by_az, "us-east-1e")}",
      "${lookup(module.eks-subnets.subnets_by_az, "us-east-1f")}",
    ]
  }

  depends_on = [
    "aws_iam_role_policy_attachment.eks_service_role_cluster_policy",
    "aws_iam_role_policy_attachment.eks_service_role_service_policy",
  ]
}

# Worker Nodes

resource "aws_cloudformation_stack" "nodes" {
  capabilities = ["CAPABILITY_IAM"]
  name         = "${var.name}"
  template_url = "https://amazon-eks.s3-us-west-2.amazonaws.com/cloudformation/2019-01-09/amazon-eks-nodegroup.yaml"

  parameters {
    ClusterControlPlaneSecurityGroup    = "${aws_security_group.master.id}"
    ClusterName                         = "${var.name}"
    KeyName                             = "${module.key.key_name}"
    NodeAutoScalingGroupDesiredCapacity = 3
    NodeAutoScalingGroupMaxSize         = 6
    NodeAutoScalingGroupMinSize         = 3
    NodeGroupName                       = "${var.name}"
    NodeImageId                         = "ami-0c5b63ec54dd3fc38"
    NodeInstanceType                    = "t2.medium"
    Subnets                             = "${join(",", module.eks-subnets.subnets)}"
    VpcId                               = "${module.eks-vpc.vpc_id}"
  }

  tags = "${local.tags}"
}
