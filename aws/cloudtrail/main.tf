resource "aws_cloudtrail" "mod" {
  name                          = var.name
  s3_bucket_name                = aws_s3_bucket.mod.id
  include_global_service_events = true
  enable_logging                = true
  enable_log_file_validation    = true

  cloud_watch_logs_group_arn    = "${aws_cloudwatch_log_group.mod.arn}:*"
  cloud_watch_logs_role_arn     = aws_iam_role.cloudwatch.arn

  tags                          = var.tags
}

resource "aws_s3_bucket" "mod" {
  bucket = "${var.name}-cloudtrail"
  acl    = "private"
  policy = data.aws_iam_policy_document.s3.json

  tags   = var.tags

  logging {
    target_bucket = "cloudtrail-logs"
    target_prefix = var.name
  }
}

resource "aws_cloudwatch_log_group" "mod" {
  name = "${var.name}-cloudtrail-logs"
}

resource "aws_iam_role" "cloudwatch" {
  name               = "${var.name}-cloudwatch"
  path               = "/service-role/"
  description        = "${var.name} cloudwatch logs role"
  assume_role_policy = data.aws_iam_policy_document.assume-role.json

  tags               = var.tags
}

resource "aws_iam_policy" "cloudwatch" {
  name        = "${var.name}-cloudwatch-policy"
  description = "${var.name} cloudwatch logs policy"
  policy      = data.aws_iam_policy_document.cloudwatch.json
}

resource "aws_iam_policy_attachment" "mod" {
  name       = "${var.name}-cloudwatch-attachment"
  roles      = [aws_iam_role.cloudwatch.name]
  policy_arn = aws_iam_policy.cloudwatch.arn
}

data "aws_iam_policy_document" "s3" {
  statement {
    sid       = "AWSCloudTrailAclCheck"
    actions   = ["s3:GetBucketAcl"]
    resources = ["arn:aws:s3:::${var.name}-cloudtrail"]

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }
  statement {
    sid       = "AWSCloudTrailWrite"
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::${var.name}-cloudtrail/*"]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "assume-role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "cloudwatch" {
  statement {
    sid       = "AWSCloudTrailCreateLogStream"
    actions   = ["logs:CreateLogStream"]
    resources = ["${aws_cloudwatch_log_group.mod.arn}:*"]
  }

  statement {
    sid       = "AWSCloudTrailPutLogEvents"
    actions   = ["logs:PutLogEvents"]
    resources = ["${aws_cloudwatch_log_group.mod.arn}:*"]
  }
}
