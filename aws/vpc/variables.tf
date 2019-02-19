variable "cidr" {
  default     = "10.0.0.0/16"
  description = "The IPv4 network range for the VPC, in CIDR notation."
}

variable "client" {
  description = "Adds txi:client tag where appropriate"
}

variable "environment" {
  description = "Adds txi:environment tag where appropriate"
}

variable "name" {
  description = "Adds Name tag where appropriate"
}
