output "master_security_group_id" {
  value = "${aws_security_group.master.id}"
}

output "node_instance_role" {
  value = "${module.nodes.node_instance_role}"
}

output "subnets" {
  value = "${module.eks-subnets.subnets}"
}

output "vpc_id" {
  value = "${module.eks-vpc.vpc_id}"
}
