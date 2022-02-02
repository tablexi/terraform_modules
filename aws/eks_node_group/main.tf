locals {
  # Node Group Cluster Autoscaler prerequisites
  # https://docs.aws.amazon.com/eks/latest/userguide/cluster-autoscaler.html#ca-prerequisites
  cluster_autoscaler_tags = {
    "k8s.io/cluster-autoscaler/${var.cluster.name}" = "owned",
    "k8s.io/cluster-autoscaler/enabled"             = "TRUE"
  }

  node_group_tags = var.cluster.uses_cluster_autoscaler ? merge(var.cluster.tags, local.cluster_autoscaler_tags) : var.cluster.tags
}

resource "aws_eks_node_group" "nodes" {
  ami_type               = var.ami_type
  capacity_type          = var.capacity_type
  cluster_name           = var.cluster.name
  disk_size              = var.disk_size
  instance_types         = var.instance_types
  node_group_name_prefix = var.node_group_name_prefix
  node_role_arn          = var.node_iam_role.arn

  remote_access {
    ec2_ssh_key = var.ec2_ssh_key
  }

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  subnet_ids = var.subnet_ids

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    var.cluster,
    var.node_iam_role,
  ]

  # Do not detect Terraform drift for the desired size, so that the node group’s
  # size can change outside of Terraform as necessary.
  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }
}

resource "aws_autoscaling_group_tag" "nodes" {
  for_each = toset(
    [for asg in flatten(
      [for resources in aws_eks_node_group.nodes.*.resources : resources.autoscaling_groups]
    ) : asg.name]
  )

  autoscaling_group_name = each.value

  dynamic "tag" {
    for_each = local.node_group_tags

    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}
