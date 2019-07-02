output "endpoint" {
  value = aws_db_instance.mod.address
}

output "env" {
  value = var.env
}

output "family" {
  value = local.family
}

output "name" {
  value = var.name
}

output "port" {
  value = local.port
}

output "rds_id" {
  value = aws_db_instance.mod.id
}

output "sg_on_rds_instance_id" {
  value = aws_security_group.sg_on_rds_instance.id
}

