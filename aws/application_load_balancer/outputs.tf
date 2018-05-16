output "dns_name" {
  value = "${module.load_balancer.dns_name}"
}

output "zone_id" {
  value = "${module.load_balancer.zone_id}"
}
