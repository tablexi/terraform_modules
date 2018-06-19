output "dns_name" {
  value = "${module.load_balancer.dns_name}"
}

output "load_balancer_arn" {
  value = "${module.load_balancer.arn}"
}

output "security_group_on_load_balancer_id" {
  value = "${aws_security_group.security_group_on_load_balancer.id}"
}

output "zone_id" {
  value = "${module.load_balancer.zone_id}"
}
