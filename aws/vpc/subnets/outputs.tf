output "private_subnets" {
  value = ["${aws_subnet.mod_private.*.id}"]
}

output "public_subnets" {
  value = ["${aws_subnet.mod_public.*.id}"]
}
