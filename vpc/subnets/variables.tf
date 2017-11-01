variable "environment_name" { }
variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}
variable "vpc_id" { }
variable "internet_gateway_id" { }
variable "private_newbits" {
  default = 8
}
variable "private_netnum_offset" {
  default = 10
}
variable "public_newbits" {
  default = 8
}
variable "public_netnum_offset" {
  default = 0
}
variable "az_to_netnum" {
  default = {
    a = 1
    b = 2
    c = 3
    d = 4
    e = 5
    f = 6
  }
}
