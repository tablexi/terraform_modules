output "dns_name" {
  value = "${module.load_balancer.dns_name}"
}

output "target_group_arns" {
  value = ["${aws_alb_target_group.target_group.*.arn}"]
}

output "zone_id" {
  value = "${module.load_balancer.zone_id}"
}

output "http_listener_arn" {
  value = "${aws_alb_listener.http_listener.arn}"
}

output "https_listener_arn" {
  value = "${aws_alb_listener.https_listener.arn}"
}
