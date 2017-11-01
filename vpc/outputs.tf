output "vpc_id" {
  value = "${aws_vpc.mod.id}"
}

output "internet_gateway_id" {
  value = "${aws_internet_gateway.mod.id}"
}
