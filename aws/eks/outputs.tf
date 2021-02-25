output "cluster_arn" {
  value = aws_eks_cluster.master.arn
}

output "main_oidc_identity" {
  value = aws_eks_cluster.master.identity[0].oidc[0].issuer
}

output "master_security_group_id" {
  value = aws_security_group.master.id
}

output "node_instance_role" {
  value = aws_iam_role.nodes.arn
}

output "oidc_provider" {
  value = aws_iam_openid_connect_provider.default.arn
}

output "subnets" {
  value = module.eks-subnets.subnets
}

output "vpc_id" {
  value = module.eks-vpc.vpc_id
}

output "elastic_ip" {
  value = var.uses_nat_gateway ? module.eks-vpc-nat-gateway[0].elastic_ip : null
}
