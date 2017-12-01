output "lb_arn" {
  value = "${aws_lb.mod.arn}"
}

output "lb_endpoint" {
  value = "${aws_lb.mod.dns_name}"
}

output "lb_zone_id" {
  value = "${aws_lb.mod.zone_id}"
}

output "sg_for_access_by_sgs_id" {
  value = "${aws_security_group.sg_for_access_by_sgs.id}"
}

output "sg_on_lb_id" {
  value = "${aws_security_group.sg_on_lb.id}"
}
