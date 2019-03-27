locals {
  default_tags = {
    Name = "${var.name}"
  }

  tags = "${merge(local.default_tags, var.tags)}"
}

resource "null_resource" "hack_for_depends_on" {
  triggers {
    depends_on_length = "${length(var.depends_on)}"
  }
}

resource "aws_cloudformation_stack" "nodes" {
  capabilities = ["CAPABILITY_IAM"]
  depends_on   = ["null_resource.hack_for_depends_on"]
  name         = "${var.name}"
  template_url = "https://amazon-eks.s3-us-west-2.amazonaws.com/cloudformation/2019-01-09/amazon-eks-nodegroup.yaml"

  parameters {
    ClusterControlPlaneSecurityGroup    = "${var.master_security_group_id}"
    ClusterName                         = "${var.name}"
    KeyName                             = "${var.key_name}"
    NodeAutoScalingGroupDesiredCapacity = "${var.capacity_desired}"
    NodeAutoScalingGroupMaxSize         = "${var.capacity_max}"
    NodeAutoScalingGroupMinSize         = "${var.capacity_min}"
    NodeGroupName                       = "${var.name}"
    NodeImageId                         = "${var.ami}"
    NodeInstanceType                    = "${var.instance_type}"
    Subnets                             = "${join(",", var.subnets)}"
    VpcId                               = "${var.vpc_id}"
  }

  tags = "${local.tags}"
}
