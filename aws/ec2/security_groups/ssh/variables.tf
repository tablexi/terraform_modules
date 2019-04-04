variable "egress_cidr_blocks" {
  default = [
    "0.0.0.0/0",
  ]

  description = "List of cidr blocks to allow outgoing access to on all ports."
}

variable "env" {
  default = "prod"
}

variable "ingress_cidr_blocks" {
  default = [
    "0.0.0.0/0",
  ]

  description = "List of cidr blocks to allow incoming access to on port 22."
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resources"
  type        = "map"
}

variable "vpc_id" {}
