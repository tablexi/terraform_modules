output "sg_on_elasticache_instance_id" {
  value = aws_security_group.sg_on_elasticache_instance.id
}

output "elasticache_parameter_group_id" {
  value = var.create_parameter_group ? aws_elasticache_parameter_group.mod[0].id : null
}
