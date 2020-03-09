output "instance_ids" {
  value = aws_instance.mod[*].id
}

output "public_ips" {
  value = var.enable_eip ? aws_eip.mod[*].public_ip : aws_instance.mod[*].public_ip
}

output "private_ips" {
  value = var.enable_eip ? aws_eip.mod[*].private_ip : aws_instance.mod[*].private_ip
}

output "security_group_on_instances" {
  value = aws_security_group.security_group_on_instances.id
}

