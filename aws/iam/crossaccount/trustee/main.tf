resource "aws_iam_group_policy" "mod" {
  name  = "${var.trustor_account_name}CrossAccountPolicy"
  group = "${var.trustee_group_name}"

  policy = <<JSON
{
  "Version": "2012-10-17",
  "Statement": {
    "Effect": "Allow",
    "Action": "sts:AssumeRole",
    "Resource": "arn:aws:iam::${var.trustor_account_arn}:role/${var.trustee_account_name}CrossAccountAccessRole"
  }
}
JSON
}
