output "subnets" {
  value = ["${aws_subnet.mod.*.id}"]
}

output "route_table_id" {
  value = "${aws_route_table.mod.*.id}"
}

output "subnets_by_az" {
  value = "${zipmap(data.aws_availability_zones.available.names, aws_subnet.mod.*.id)}"
}
