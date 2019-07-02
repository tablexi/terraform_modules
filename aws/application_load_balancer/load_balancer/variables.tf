variable "name" {
  description = "(Required) The name of this load balancer."
  type        = string
}

variable "security_groups" {
  description = "(Required) A list of security group IDs to attach to the load balancer."
  type        = list(string)
}

variable "subnets" {
  description = "(Required) A list of subnet IDs to attach to the load balancer."
  type        = list(string)
}

variable "access_logs_enabled" {
  description = "(Optional) Boolean to enable / disable access_logs. Defaults to false."
  default     = false
}

variable "internal" {
  description = "(Optional) If true, the LB will be internal. Default false."
  default     = false
}

variable "tags" {
  default     = {}
  description = "(Optional) A mapping of tags to assign to the resources"
  type        = map(string)
}

