output "dns_name" {
  value = "${module.load_balancer.dns_name}"
}

output "http_listener_arn" {
  value = "${aws_alb_listener.http_listener.arn}"
}

output "https_listener_arn" {
  value = "${aws_alb_listener.https_listener.arn}"
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
