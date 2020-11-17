output "subnets" {
  value = aws_subnet.mod[*].id
}

output "route_table_id" {
  value = element(aws_route_table.mod[*].id, 0)
}

output "subnets_by_az" {
  value = { for subnet in aws_subnet.mod: subnet.availability_zone => subnet.id }
}
