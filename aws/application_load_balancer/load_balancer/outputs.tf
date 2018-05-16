output "arn" {
  value = "${element(coalescelist(aws_alb.load_balancer.*.arn, aws_alb.load_balancer_with_access_logs.*.arn), 0)}"
}

output "dns_name" {
  value = "${element(coalescelist(aws_alb.load_balancer.*.dns_name, aws_alb.load_balancer_with_access_logs.*.dns_name), 0)}"
}

output "zone_id" {
  value = "${element(coalescelist(aws_alb.load_balancer.*.zone_id, aws_alb.load_balancer_with_access_logs.*.zone_id), 0)}"
}
