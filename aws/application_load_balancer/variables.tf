variable "certificate_arn" {
  description = "(Required) The ARN of the server certificate to use for the HTTPS listener."
  type        = string
}

variable "environment" {
  description = "(Required) The environment of this load balancer. This is usually 'stage' or 'production'."
  type        = string
}

variable "instances" {
  description = "(Required) A list of instance IDs to attach to the load balancer."
  type        = list(string)
}

variable "name" {
  description = "(Required) The name of this load balancer. This is appended with the environment to set the name in AWS."
  type        = string
}

variable "security_group_for_instances" {
  description = "(Required) The ID of the security group on the instances used as targets. This is used to create rules which allow the load balancer to access the targets via HTTP and HTTPS."
  type        = string
}

variable "subnets" {
  description = "(Required) A list of subnet IDs to attach to the load balancer."
  type        = list(string)
}

variable "vpc_id" {
  description = "(Required) The identifier of the VPC in which to create the resources related to this load balancer."
  type        = string
}

variable "access_logs_enabled" {
  description = "(Optional) Boolean to enable / disable access_logs. Defaults to false."
  default     = false
}

variable "health_check_path" {
  description = "(Optional) The destination for the health check request. Default /healthz."
  default     = "/healthz"
}

variable "health_check_matcher" {
  description = "(Optional) Health check matcher for the HTTP target group. Default '200,301'."
  default     = "200,301"
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

variable "redirect_domains" {
  description = "(Optional) Map of domains to redirect. Keys are domains to redirect from, and values are domains to redirect to. Default {}."
  default     = {}
}

variable "redirect_http_to_https" {
  description = "(Optional) If true, the HTTP listener will redirect to HTTPS. Default false."
  default     = false
}

variable "redirect_http_to_https_status_code" {
  description = "(Optional) If redirect_http_to_https is true, the HTTP status code that will be used for the redirect. Default HTTP_301."
  default     = "HTTP_301"
}

variable "ssl_policy" {
  description = "(Optional) The name of the SSL Policy for the HTTPS listener. Default ELBSecurityPolicy-TLS-1-2-2017-01."
  default     = "ELBSecurityPolicy-TLS-1-2-2017-01"
}

variable "tags" {
  default     = {}
  description = "(Optional) A mapping of tags to assign to the resources"
  type        = map(string)
}

variable "target_group_port" {
  description = "(Optional) Port for the targets in the HTTP target group. Default '80'."
  default     = "80"
}

variable "target_group_protocol" {
  description = "(Optional) Protocol for the targets in the HTTP target group. Default 'HTTP'."
  default     = "HTTP"
}

