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

variable "uses_nat_gateway" {
  description = "Enable creation of this NAT Gateway and associated subnet/routes"
  default     = false
  type        = bool
}

variable "availability_zone" {
  description = "Which AZ to create the NAT Gateway"
  default     = "us-east-1a"
}

variable "subnet_cidr_newbits" {
  default     = 8
  description = "The subnets modifier of a routing mask or decrease the scope of the cidr_block by the given bits."
}

variable "subnet_cidr_netnum_offset" {
  default     = 0
  description = "Offset the subnets netnum by a specific amount."
}
