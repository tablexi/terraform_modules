variable "env" {}

variable "idle_timeout" {
  description = "The time in seconds that the connection is allowed to be idle"
  default = 60
}

variable "internal" {
  description = "The LB is only accessible inside the VPC"
  default = false
}

variable "ip_address_type" {
  description = "The type of IP addresses used by the subnets for the LB"
  default = "dualstack"
}

variable "name" {}

variable "subnets" {
  description = "List of subnets to attach the LB to"
  default = []
}

variable "type" {
  description = "Either a application or network LB"
}

variable "vpc_id" {
  description = "The identifier of the VPC in which to create the LB"
}
