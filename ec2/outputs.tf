output "instance_ids" {
  value = ["${aws_instance.mod.*.id}"]
}

output "public_ips" {
  value = ["${aws_instance.mod.*.public_ip}"]
}
