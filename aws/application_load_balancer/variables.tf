variable "certificate_arn" {
  description = "(Required) The ARN of the server certificate to use for the HTTPS listener."
  type        = "string"
}

variable "environment" {
  description = "(Required) The environment of this load balancer. This is usually 'stage' or 'production'."
  type        = "string"
}

variable "instances" {
  description = "(Required) A list of instance IDs to attach to the load balancer."
  type        = "list"
}

variable "instances_count" {
  description = "(Required) The number of instances. This is required because of the Terraform bug https://github.com/hashicorp/terraform/issues/10857."
  type        = "string"
}

variable "name" {
  description = "(Required) The name of this load balancer. This is appended with the environment to set the name in AWS."
  type        = "string"
}

variable "security_group_for_instances" {
  description = "(Required) The ID of the security group on the instances used as targets. This is used to create rules which allow the load balancer to access the targets via HTTP and HTTPS."
  type        = "string"
}

variable "subnets" {
  description = "(Required) A list of subnet IDs to attach to the load balancer."
  type        = "list"
}

variable "vpc_id" {
  description = "(Required) The identifier of the VPC in which to create the resources related to this load balancer."
  type        = "string"
}

variable "access_logs_enabled" {
  description = "(Optional) Boolean to enable / disable access_logs. Defaults to false."
  default     = false
}

variable "health_check_path" {
  description = "(Optional) The destination for the health check request. Default /healthz."
  default     = "/healthz"
}

variable "http_health_check_matcher" {
  description = "(Optional) Health check matcher for the HTTP target group. Default '200,301'."
  default     = "200,301"
}

variable "https_health_check_matcher" {
  description = "(Optional) Health check matcher for the HTTPS target group. Default '200'."
  default     = "200"
}

variable "https_target_group" {
  description = "(Optional) If true, the HTTPS listener will forward to a HTTPS target group. If false, the HTTPS listener will forward to a HTTP target group. Default true."
  default     = true
}

variable "ingress_cidr_blocks" {
  description = "(Optional) List of CIDR blocks that can access the load balancer."
  default     = ["0.0.0.0/0"]
}

variable "ingress_security_groups" {
  description = "(Optional) List of security group IDs that can access the load balancer."
  default     = []
}

variable "internal" {
  description = "(Optional) If true, the LB will be internal. Default false."
  default     = false
}

variable "ssl_policy" {
  description = "(Optional) The name of the SSL Policy for the HTTPS listener. Default ELBSecurityPolicy-TLS-1-2-2017-01."
  default     = "ELBSecurityPolicy-TLS-1-2-2017-01"
}
