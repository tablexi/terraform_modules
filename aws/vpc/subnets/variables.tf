variable "vpc_id" {
  description = "The unique ID of the VPC."
}

variable "internet_gateway_id" {
  description = "The unique ID of the Internet gateway."
}

variable "public" {
  default     = true
  description = "Provide access from the outside world"
}

variable "newbits" {
  default     = 8
  description = "The subnets modifier of a routing mask or decrease the scope of the cidr_block by the given bits."
}

variable "netnum_offset" {
  default     = 0
  description = "Offset the subnets netnum by a specific amount."
}

variable "name" {
  description = "Adds Name tag where appropriate"
}

variable "client" {
  description = "Adds txi:client tag where appropriate"
}

variable "infra_environment" {
  description = "Adds txi:infra_environment tag where appropriate"
}

variable "application_environment" {
  description = "Adds txi:application_environment tag where appropriate"
}
