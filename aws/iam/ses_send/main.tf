resource "aws_iam_group" "mod" {
  name = "ses_senders"
}

data "aws_iam_policy_document" "mod" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    actions = [
      "ses:SendRawEmail",
      "ses:SendEmail",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_group_policy" "mod" {
  name  = "AmazonSesSendingAccess"
  group = aws_iam_group.mod.id

  policy = data.aws_iam_policy_document.mod.json
}

resource "aws_iam_group_membership" "mod" {
  count = length(var.users)  > 0 ? 1 : 0
  name  = "app-server-group-membership"
  users = var.users
  group = aws_iam_group.mod.name
}

resource "aws_iam_role_policy" "mod" {
  count      = length(var.roles)
  name       = "AmazonSesSendingAccess"
  policy     = data.aws_iam_policy_document.mod.json
  role       = var.roles[count.index]
}

