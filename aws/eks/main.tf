locals {
  elb_discovery_tag = var.uses_nat_gateway ? "kubernetes.io/role/internal-elb" : "kubernetes.io/role/elb"
  tags              = merge({ Name = var.name }, var.tags)

  subnet_tags = merge(local.tags, {
    (local.elb_discovery_tag) = true,
    "kubernetes.io/cluster/${var.name}" = "shared"
  })
}

module "eks-vpc" {
  source = "../vpc"

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

  exclude_names = var.subnet_module.exclude_names
  internet_gateway_id = module.eks-vpc.internet_gateway_id
  nat_gateway_id      = var.uses_nat_gateway ? module.eks-vpc-nat-gateway[0].nat_gateway_id : 0
  netnum_offset = var.subnet_module.netnum_offset
  tags = local.subnet_tags
  vpc_id = module.eks-vpc.vpc_id
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

resource "aws_security_group" "master" {
  name   = var.name
  tags   = local.tags
  vpc_id = module.eks-vpc.vpc_id
}

resource "aws_security_group_rule" "master_egress" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.master.id
  to_port           = 0
  type              = "egress"
}

resource "aws_eks_cluster" "master" {
  name     = var.name
  role_arn = aws_iam_role.eks_service_role.arn

  vpc_config {
    security_group_ids = [aws_security_group.master.id]

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
  instance_types  = [var.instance_type]
  node_group_name = "default"
  node_role_arn   = aws_iam_role.nodes.arn

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
    aws_eks_cluster.master,
    aws_iam_role_policy_attachment.nodes-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.nodes-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.nodes-AmazonEC2ContainerRegistryReadOnly,
  ]
}

data "tls_certificate" "default" {
  url = aws_eks_cluster.master.identity.0.oidc.0.issuer
}

# IAM Service Account integration
# https://docs.aws.amazon.com/eks/latest/userguide/enable-iam-roles-for-service-accounts.html
resource "aws_iam_openid_connect_provider" "default" {
  url = aws_eks_cluster.master.identity[0].oidc[0].issuer

  client_id_list = [
    "sts.amazonaws.com",
  ]

  thumbprint_list = [data.tls_certificate.default.certificates.0.sha1_fingerprint]
}
