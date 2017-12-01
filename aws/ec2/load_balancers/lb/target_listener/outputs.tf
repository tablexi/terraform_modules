output "listener_arn" {
  value = "${element(concat(aws_lb_listener.mod.*.arn, list("")), 0)}"
}
