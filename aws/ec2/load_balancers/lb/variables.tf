variable "env" {}

variable "internal" {
  description = "The LB is only accessible inside the VPC"
  default = false
}

variable "name" {}

variable "subnets" {
  description = "List of subnets to attach the LB to"
  type = "list"
}

variable "type" {
  description = "Either a application or network LB"
}

variable "vpc_id" {
  description = "The identifier of the VPC in which to create the LB"
}
