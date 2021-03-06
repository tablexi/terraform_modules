variable "name" {
  description = "Name of the gateway"
}

variable "vpc_id" {
  description = "The unique ID of the VPC."
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resources"
  type        = map(string)
}

variable "internet_gateway_id" {
  description = "Internet Gateway router for internet traffic"
}

variable "exclude_availability_zones" {
  description = "Which AZ(s) should NOT be used (all other zones will have a subnet created)"
  type        = list(string)
  default     = []
}

variable "subnet_cidr_newbits" {
  default     = 8
  description = "The subnets modifier of a routing mask or decrease the scope of the cidr_block by the given bits."
}

variable "subnet_cidr_netnum_offset" {
  default     = 0
  description = "Offset the subnets netnum by a specific amount."
}
