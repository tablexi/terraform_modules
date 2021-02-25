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

resource "aws_iam_policy" "mod" {
  name = "AmazonSesSendingAccess"

  policy = data.aws_iam_policy_document.mod.json
}

resource "aws_iam_policy_attachment" "mod" {
  name       = "ses-sending-policy-attachment"
  users      = var.users
  roles      = var.roles
  policy_arn = aws_iam_policy.mod.arn
}
