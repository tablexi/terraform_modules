output "nat_gateway_id" {
  value = var.uses_nat_gateway ? aws_nat_gateway.gw[0].id : -1
}
