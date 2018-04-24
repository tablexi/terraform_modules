output "dns_name" {
  value = "${aws_alb.load_balancer.dns_name}"
}

output "zone_id" {
  value = "${aws_alb.load_balancer.zone_id}"
}
