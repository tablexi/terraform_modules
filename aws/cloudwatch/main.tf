resource "aws_cloudwatch_log_group" "mod" {
  name = "${var.name}-cloudwatch-logs"
}

resource "aws_iam_role" "mod" {
  name               = "${var.name}-cloudwatch"
  path               = "/service-role/"
  description        = "${var.name} cloudwatch logs role"
  assume_role_policy = data.aws_iam_policy_document.assume-role.json

  tags               = var.tags
}

resource "aws_iam_policy" "mod" {
  name        = "${var.name}-cloudwatch-policy"
  description = "${var.name} cloudwatch logs policy"
  policy      = data.aws_iam_policy_document.cloudwatch.json
}

resource "aws_iam_policy_attachment" "mod" {
  name       = "${var.name}-cloudwatch-attachment"
  roles      = [aws_iam_role.mod.name]
  policy_arn = aws_iam_policy.mod.arn
}

data "aws_iam_policy_document" "assume-role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = var.services
    }
  }
}

data "aws_iam_policy_document" "cloudwatch" {
  statement {
    sid       = "AWSCloudWatchCreateLogStream"
    actions   = ["logs:CreateLogStream"]
    resources = ["${aws_cloudwatch_log_group.mod.arn}:*"]
  }

  statement {
    sid       = "AWSCloudWatchPutLogEvents"
    actions   = ["logs:PutLogEvents"]
    resources = ["${aws_cloudwatch_log_group.mod.arn}:*"]
  }
}
