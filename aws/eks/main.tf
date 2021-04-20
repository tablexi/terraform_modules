locals {
  elb_discovery_tag = var.uses_nat_gateway ? "kubernetes.io/role/internal-elb" : "kubernetes.io/role/elb"
  tags              = merge({ Name = var.name, eks_cluster_name = var.name }, var.tags)

  subnet_tags = merge(local.tags, {
    (local.elb_discovery_tag)           = true,
    "kubernetes.io/cluster/${var.name}" = "shared"
  })

  # Node Group Cluster Autoscaler prerequisites
  # https://docs.aws.amazon.com/eks/latest/userguide/cluster-autoscaler.html#ca-prerequisites
  node_group_tags = var.uses_cluster_autoscaler ? merge(
    local.tags,
    {
      "k8s.io/cluster-autoscaler/${var.name}" = "owned",
      "k8s.io/cluster-autoscaler/enabled"     = "TRUE"
    },
  ) : local.tags
}

module "eks-vpc" {
  source = "../vpc"

  cidr = var.vpc_cidr
  tags = merge(
    local.tags,
    {
      "kubernetes.io/cluster/${var.name}" = "shared"
    },
  )
}

module "eks-vpc-nat-gateway" {
  source = "../nat_gateway"

  count                      = var.uses_nat_gateway ? 1 : 0
  exclude_availability_zones = var.subnet_module.exclude_names
  internet_gateway_id        = module.eks-vpc.internet_gateway_id
  name                       = var.name
  subnet_cidr_netnum_offset  = 100 # So that it doesn't vary based on capacity
  vpc_id                     = module.eks-vpc.vpc_id

  tags = merge(
    local.tags,
    {
      "kubernetes.io/cluster/${var.name}" = "shared"
    },
  )
}

module "eks-subnets" {
  source = "../vpc/subnets"

  exclude_names       = var.subnet_module.exclude_names
  internet_gateway_id = module.eks-vpc.internet_gateway_id
  nat_gateway_id      = var.uses_nat_gateway ? module.eks-vpc-nat-gateway[0].nat_gateway_id : 0
  netnum_offset       = var.subnet_module.netnum_offset
  tags                = local.subnet_tags
  vpc_id              = module.eks-vpc.vpc_id
}

resource "aws_iam_role" "eks_service_role" {
  name = var.name
  tags = local.tags

  assume_role_policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Principal = {
            Service = "eks.amazonaws.com"
          }
          Action = "sts:AssumeRole"
        },
      ]
    }
  )
}

resource "aws_iam_role_policy_attachment" "eks_service_role_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_service_role.name
}

resource "aws_iam_role_policy_attachment" "eks_service_role_service_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks_service_role.name
}

resource "aws_security_group" "main" {
  name   = var.name
  tags   = local.tags
  vpc_id = module.eks-vpc.vpc_id
}

resource "aws_security_group_rule" "main_egress" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.main.id
  to_port           = 0
  type              = "egress"
}

resource "aws_eks_cluster" "main" {
  name     = var.name
  role_arn = aws_iam_role.eks_service_role.arn
  tags     = local.tags

  vpc_config {
    security_group_ids = [aws_security_group.main.id]

    subnet_ids = module.eks-subnets.subnets
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_service_role_cluster_policy,
    aws_iam_role_policy_attachment.eks_service_role_service_policy,
  ]
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
  name               = "${var.name}-nodes"
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

resource "aws_eks_node_group" "default" {
  cluster_name    = var.name
  capacity_type   = var.capacity_type
  instance_types  = var.instance_types
  disk_size       = var.disk_size
  node_group_name = "default"
  node_role_arn   = aws_iam_role.nodes.arn
  tags            = local.node_group_tags

  remote_access {
    ec2_ssh_key = var.ec2_ssh_key
  }

  scaling_config {
    desired_size = var.capacity_desired
    max_size     = var.capacity_max
    min_size     = var.capacity_min
  }

  subnet_ids = module.eks-subnets.subnets

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_eks_cluster.main,
    aws_iam_role_policy_attachment.nodes-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.nodes-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.nodes-AmazonEC2ContainerRegistryReadOnly,
  ]

  # This is the only way to allow the node group to scale independently of the terraform state.
  # We can use terraform to define the descired_size to start, but don't want to impede any other scaling mechanisms.
  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }
}

data "tls_certificate" "default" {
  url = aws_eks_cluster.main.identity.0.oidc.0.issuer
}

# IAM Service Account integration
# https://docs.aws.amazon.com/eks/latest/userguide/enable-iam-roles-for-service-accounts.html
resource "aws_iam_openid_connect_provider" "default" {
  url = aws_eks_cluster.main.identity[0].oidc[0].issuer

  client_id_list = [
    "sts.amazonaws.com",
  ]

  thumbprint_list = [data.tls_certificate.default.certificates.0.sha1_fingerprint]
}

# Cluster Autoscaler IAM Policy and Role
# https://docs.aws.amazon.com/eks/latest/userguide/cluster-autoscaler.html#ca-create-policy

data "aws_iam_policy_document" "cluster-autoscaler-trust-relationship" {
  version = "2012-10-17"

  statement {
    effect = "Allow"
    principals {
      type = "Federated"
      identifiers = [
        aws_iam_openid_connect_provider.default.arn,
      ]
    }
    actions = ["sts:AssumeRoleWithWebIdentity"]
    condition {
      test     = "StringEquals"
      variable = "${trimprefix(aws_eks_cluster.main.identity[0].oidc[0].issuer, "https://")}:sub"
      values   = ["system:serviceaccount:${var.cluster_autoscaler.namespace}:${var.cluster_autoscaler.serviceaccount}"]
    }
  }
}

data "aws_iam_policy_document" "cluster-autoscaler" {
  version = "2012-10-17"

  statement {
    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:DescribeTags",
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup",
      "ec2:DescribeLaunchTemplateVersions",
    ]
    effect    = "Allow"
    resources = ["*"]
  }
}

resource "aws_iam_role" "cluster-autoscaler" {
  count = var.uses_cluster_autoscaler ? 1 : 0
  name  = "cluster-autoscaler-${var.name}-serviceaccount"

  assume_role_policy = data.aws_iam_policy_document.cluster-autoscaler-trust-relationship.json
}

resource "aws_iam_role_policy" "cluster-autoscaler-policy" {
  count = var.uses_cluster_autoscaler ? 1 : 0
  name  = "${var.name}ClusterAutoscalerPolicy"
  role  = aws_iam_role.cluster-autoscaler[0].id

  policy = data.aws_iam_policy_document.cluster-autoscaler.json
}
