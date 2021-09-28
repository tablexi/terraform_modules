locals {
  # Node Group Cluster Autoscaler prerequisites
  # https://docs.aws.amazon.com/eks/latest/userguide/cluster-autoscaler.html#ca-prerequisites
  cluster_autoscaler_tags = {
    "k8s.io/cluster-autoscaler/${var.cluster.name}" = "owned",
    "k8s.io/cluster-autoscaler/enabled"             = "TRUE"
  }

  node_group_tags = var.cluster.uses_cluster_autoscaler ? merge(var.cluster.tags, local.cluster_autoscaler_tags) : var.cluster.tags
}

data "aws_iam_policy_document" "nodes_assume_role_policy" {
  version = "2012-10-17"

  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "nodes" {
  name_prefix        = var.node_group_name_prefix
  assume_role_policy = data.aws_iam_policy_document.nodes_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "nodes-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.nodes.name
}

resource "aws_iam_role_policy_attachment" "nodes-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.nodes.name
}

resource "aws_iam_role_policy_attachment" "nodes-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.nodes.name
}

resource "aws_eks_node_group" "nodes" {
  ami_type               = var.ami_type
  capacity_type          = var.capacity_type
  cluster_name           = var.cluster.name
  disk_size              = var.disk_size
  instance_types         = var.instance_types
  node_group_name_prefix = var.node_group_name_prefix
  node_role_arn          = aws_iam_role.nodes.arn
  tags                   = local.node_group_tags

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
    aws_iam_role_policy_attachment.nodes-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.nodes-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.nodes-AmazonEC2ContainerRegistryReadOnly,
  ]

  # Do not detect Terraform drift for the desired size, so that the node group’s
  # size can change outside of Terraform as necessary.
  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }
}
