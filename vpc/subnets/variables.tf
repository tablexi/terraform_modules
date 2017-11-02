variable "name" {
  description = "The name of the subnet group. Also, used to tag the subnets."
}

variable "vpc_id" {
  description = "The unique ID of the VPC."
}

variable "internet_gateway_id" {
  description = "The unique ID of the Internet gateway."
}

variable "private_newbits" {
  default = 8
  description = "The private subnets modifier of a routing mask or decrease the scope of the cidr_block by the given bits."
}

variable "private_netnum_offset" {
  default = 10
  description = "Offset the private subnets netnum by a specific amount."
}

variable "public_newbits" {
  default = 8
  description = "The public subnets modifier of a routing mask or decrease the scope of the cidr_block by the given bits."
}

variable "public_netnum_offset" {
  default = 0
  description = "Offset the public subnets netnum by a specific amount."
}
