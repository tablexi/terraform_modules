output "nat_gateway_id" {
  value = aws_nat_gateway.gw.id
}

output "elastic_ip" {
  value = aws_eip.nat-gw-eip.public_ip
}
