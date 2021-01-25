variable "name" {
  description = "A prefix for the CloudWatch log group and roles"
}

variable "tags" {
  default     = {}
  description = "(Optional) A mapping of tags to assign to the resources"
  type        = map(string)
}

variable "services" {
  default     = []
  description = "(Optional) The services to which CloudWatch should have access"
  type        = list(string)
}
