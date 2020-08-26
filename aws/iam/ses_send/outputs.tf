output "group_id" {
  value = length(var.users)  > 0 ? aws_iam_group.mod[0].id : ""
}

