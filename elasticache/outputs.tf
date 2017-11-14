output "sg_for_access_by_sgs_id" {
  value = "${aws_security_group.sg_for_access_by_sgs.id}"
}

output "sg_on_elasticache_instance_id" {
  value = "${aws_security_group.sg_on_elasticache_instance.id}"
}
