output "cidr_block" {
  value = "${aws_vpc.mod.cidr_block}"
}

output "internet_gateway_id" {
  value = "${aws_internet_gateway.mod.id}"
}

output "vpc_id" {
  value = "${aws_vpc.mod.id}"
}
