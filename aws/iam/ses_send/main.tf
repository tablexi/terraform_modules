resource "aws_iam_group" "mod" {
  name = "ses_senders"
}

resource "aws_iam_group_policy" "mod" {
  name  = "AmazonSesSendingAccess"
  group = "${aws_iam_group.mod.id}"

  policy = <<JSON
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
              "ses:SendRawEmail",
              "ses:SendEmail"
            ],
            "Resource": "*"
        }
    ]
}
JSON
}

resource "aws_iam_group_membership" "mod" {
  name  = "app-server-group-membership"
  users = ["${var.users}"]
  group = "${aws_iam_group.mod.name}"
}
