resource "aws_iam_role" "mod" {
    name = "${var.trustee_account_name}CrossAccountAccessRole"
    assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${var.trustee_account_arn}:root"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "mod" {
  name = "${var.trustee_account_name}CrossAccountAdminAccess"
  path = "/"
  description = "${var.trustee_account_name} full access policy with delete provisions for cross account access."
  policy = "${var.access_policy}"
}

resource "aws_iam_policy_attachment" "mod" {
  name = "${var.trustee_account_name}CrossAccountAdminAccess"
  roles = ["${aws_iam_role.mod.name}"]
  policy_arn = "${aws_iam_policy.mod.arn}"
}
