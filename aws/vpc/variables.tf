variable "cidr" {
  default     = "10.0.0.0/16"
  description = "The IPv4 network range for the VPC, in CIDR notation."
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resources"
  type        = map(string)
}

