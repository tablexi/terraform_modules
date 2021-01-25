resource "aws_cloudtrail" "mod" {
  name                          = var.name
  s3_bucket_name                = aws_s3_bucket.mod.id
  include_global_service_events = true
  enable_logging                = true
  enable_log_file_validation    = true

  cloud_watch_logs_group_arn    = var.cloud_watch_logs_group_arn
  cloud_watch_logs_role_arn     = var.cloud_watch_logs_role_arn

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
