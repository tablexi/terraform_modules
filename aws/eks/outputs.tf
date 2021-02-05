output "cluster_arn" {
  value = aws_eks_cluster.main.arn
}

output "cluster_security_group_id" {
  value = aws_eks_cluster.main.vpc_config[0].cluster_security_group_id
}

output "main_oidc_identity" {
  value = aws_eks_cluster.main.identity[0].oidc[0].issuer
}

output "main_security_group_id" {
  value = aws_security_group.main.id
}

output "node_instance_role" {
  value = aws_iam_role.nodes.arn
}

output "cluster_security_group_id" {
  value = aws_eks_cluster.master.vpc_config[0].cluster_security_group_id
}

output "oidc_provider" {
  value = aws_iam_openid_connect_provider.default.arn
}

output "subnets" {
  value = module.eks-subnets.subnets
}

output "eks-vpc" {
  value = module.eks-vpc
}

output "elastic_ip" {
  value = var.uses_nat_gateway ? module.eks-vpc-nat-gateway[0].elastic_ip : null
}

output "vpc" {
  value = module.eks-vpc
}
