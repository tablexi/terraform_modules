output "instance_ids" {
  value = ["${aws_instance.mod.*.id}"]
}

output "public_ips" {
  # Cannot use lists in a conditional statement
  # https://github.com/hashicorp/terraform/issues/12453
  value = ["${split(",", var.enable_eip ? join(",", aws_eip.mod.*.public_ip) : join(",", aws_instance.mod.*.public_ip))}"]
}

output "security_group_on_instances" {
  value = "${aws_security_group.security_group_on_instances.id}"
}
