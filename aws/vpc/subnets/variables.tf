variable "vpc_id" {
  description = "The unique ID of the VPC."
}

variable "internet_gateway_id" {
  description = "The unique ID of the Internet gateway."
}

variable "nat_gateway_id" {
  description = "The ID of the NAT Gateway (if applicable)"
  default = 0
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

variable "exclude_names" {
  default     = []
  description = "(Optional) List of blacklisted Availability Zone names."
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resources"
  type        = map(string)
}

