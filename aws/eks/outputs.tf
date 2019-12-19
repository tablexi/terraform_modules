output "master_security_group_id" {
  value = aws_security_group.master.id
}

output "node_instance_role" {
  value = aws_iam_role.nodes.arn
}

output "subnets" {
  value = module.eks-subnets.subnets
}

output "vpc_id" {
  value = module.eks-vpc.vpc_id
}

