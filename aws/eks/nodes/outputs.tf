output "node_instance_role" {
  value = "${aws_cloudformation_stack.nodes.outputs["NodeInstanceRole"]}"
}
