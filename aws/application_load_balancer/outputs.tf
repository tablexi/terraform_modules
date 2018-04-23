output "dns_name" {
  value = "${aws_alb.load_balancer.dns_name}"
}
