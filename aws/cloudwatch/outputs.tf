output "group_arn" {
  value = "${aws_cloudwatch_log_group.mod.arn}:*"
}

output "role_arn" {
  value = aws_iam_role.mod.arn
}
