resource "aws_iam_group" "mod" {
  name = "ses_senders"
}

resource "aws_iam_group_policy" "mod" {
  name  = "AmazonSesSendingAccess"
  group = aws_iam_group.mod.id

  policy = jsonencode(
    {
      Statement = [
        {
          Action = [
            "ses:SendRawEmail",
            "ses:SendEmail",
          ]
          Effect   = "Allow"
          Resource = "*"
        },
      ]
      Version = "2012-10-17"
    }
  )
}

resource "aws_iam_group_membership" "mod" {
  name  = "app-server-group-membership"
  users = var.users
  group = aws_iam_group.mod.name
}

