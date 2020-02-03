variable "load_balancer" {
  description = "application_load_balancer module to attach rules to"
}

variable "dns_zone" {
  description = "aws_route53_zone to create DNS alias records in"
}

variable "rules" {
  description = "Map of redirects to create, with key as hostname and value as map of host and path"
}
