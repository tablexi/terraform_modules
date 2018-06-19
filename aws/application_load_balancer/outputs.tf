output "dns_name" {
  value = "${module.load_balancer.dns_name}"
}

output "load_balancer_arn" {
  value = "${module.load_balancer.arn}"
}

output "zone_id" {
  value = "${module.load_balancer.zone_id}"
}
