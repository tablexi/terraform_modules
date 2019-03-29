locals {
  default_tags = {
    Name = "${var.name}"
  }

  tags = "${merge(local.default_tags, var.tags)}"
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

module "eks-vpc" {
  source = "../../vpc"

  tags = "${merge(local.tags, map("kubernetes.io/cluster/${var.name}", "shared"))}"
}

module "eks-subnets" {
  source = "../../vpc/subnets"

  internet_gateway_id = "${module.eks-vpc.internet_gateway_id}"
  tags                = "${merge(local.tags, map("kubernetes.io/cluster/${var.name}", "shared"))}"
  vpc_id              = "${module.eks-vpc.vpc_id}"
}

resource "aws_iam_role" "eks_service_role" {
  name = "${var.name}"
  tags = "${local.tags}"

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
}

resource "aws_iam_role_policy_attachment" "eks_service_role_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = "${aws_iam_role.eks_service_role.name}"
}

resource "aws_iam_role_policy_attachment" "eks_service_role_service_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = "${aws_iam_role.eks_service_role.name}"
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

# =====================================

module "nodes" {
  source = "../nodes"

  ami                      = "${var.ami}"
  capacity_desired         = "${var.capacity_desired}"
  capacity_max             = "${var.capacity_max}"
  capacity_min             = "${var.capacity_min}"
  depends_on               = ["${module.master.endpoint}"]
  instance_type            = "${var.instance_type}"
  key_name                 = "${var.key_name}"
  master_security_group_id = "${module.master.master_security_group_id}"
  name                     = "${var.name}"
  subnets                  = "${module.master.subnets}"
  tags                     = "${var.tags}"
  vpc_id                   = "${module.master.vpc_id}"
}

resource "aws_cloudwatch_log_group" "logs" {
  name = "${var.name}"
  tags = "${var.tags}"
}

resource "aws_iam_policy" "cluster-logging" {
  name = "${var.name}-logging"

  policy = <<-POLICY
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Action": [
            "logs:DescribeLogGroups"
          ],
          "Resource": [
            "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group::log-stream:*"
          ]
        },
        {
          "Effect": "Allow",
          "Action": [
            "logs:DescribeLogStreams"
          ],
          "Resource": [
            "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:${aws_cloudwatch_log_group.logs.name}:log-stream:*"
          ]
        },
        {
          "Effect": "Allow",
          "Action": [
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ],
          "Resource": [
            "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:${aws_cloudwatch_log_group.logs.name}:log-stream:fluentd-cloudwatch"
          ]
        }
      ]
    }
    POLICY
}

resource "aws_iam_role_policy_attachment" "cluster-logging" {
  policy_arn = "${aws_iam_policy.cluster-logging.arn}"
  role       = "${replace(module.nodes.node_instance_role, "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/", "")}"
}
