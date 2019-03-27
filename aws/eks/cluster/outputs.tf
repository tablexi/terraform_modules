output "master_security_group_id" {
  value = "${module.master.master_security_group_id}"
}

output "subnets" {
  value = "${module.master.subnets}"
}

output "vpc_id" {
  value = "${module.master.vpc_id}"
}

output "node_instance_role" {
  value = "${module.nodes.node_instance_role}"
}
