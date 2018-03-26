resource "aws_iam_policy" "mod" {
  name        = "${var.datadog_policy_name}"
  description = "${var.datadog_policy_name}"
  path        = "/"

  policy = <<JSON
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "autoscaling:Describe*",
        "cloudtrail:DescribeTrails",
        "cloudtrail:GetTrailStatus",
        "cloudwatch:Describe*",
        "cloudwatch:Get*",
        "cloudwatch:List*",
        "ec2:Describe*",
        "ec2:Get*",
        "ecs:Describe*",
        "ecs:List*",
        "elasticache:Describe*",
        "elasticache:List*",
        "elasticloadbalancing:Describe*",
        "elasticmapreduce:List*",
        "iam:Get*",
        "iam:List*",
        "kinesis:Get*",
        "kinesis:List*",
        "kinesis:Describe*",
        "logs:Get*",
        "logs:Describe*",
        "logs:TestMetricFilter",
        "rds:Describe*",
        "rds:List*",
        "route53:List*",
        "s3:GetBucketTagging",
        "ses:Get*",
        "ses:List*",
        "sns:List*",
        "sns:Publish",
        "sqs:GetQueueAttributes",
        "sqs:ListQueues",
        "sqs:ReceiveMessage"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
JSON
}

resource "aws_iam_role" "mod" {
  name = "${var.datadog_role_name}"

  assume_role_policy = <<JSON
{
  "Version": "2012-10-17",
  "Statement": {
    "Effect": "Allow",
    "Principal": { "AWS": "arn:aws:iam::${var.datadog_aws_account}:root" },
    "Action": "sts:AssumeRole",
    "Condition": { "StringEquals": { "sts:ExternalId": "${var.datadog_external_id}" } }
  }
}
JSON
}

resource "aws_iam_policy_attachment" "mod" {
  name       = "Allow Datadog PolicyAccess via Role"
  policy_arn = "${aws_iam_policy.mod.arn}"
  roles      = ["${aws_iam_role.mod.name}"]
}
