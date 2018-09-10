variable "name" {
  description = "Used to tag the VPC for easier recognition."
}

variable "cidr" {
  default     = "10.0.0.0/16"
  description = "The IPv4 network range for the VPC, in CIDR notation."
}
