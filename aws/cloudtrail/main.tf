resource "aws_cloudtrail" "mod" {
  name                          = var.name
  s3_bucket_name                = aws_s3_bucket.mod.id
  include_global_service_events = true
  enable_logging                = true
  tags                          = var.tags
}

resource "aws_s3_bucket" "mod" {
  bucket = "${var.name}-cloudtrail"
  acl    = "private"

  policy = <<-JSON
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "AWSCloudTrailAclCheck",
        "Effect": "Allow",
        "Principal": {
          "Service": "cloudtrail.amazonaws.com"
        },
        "Action": "s3:GetBucketAcl",
        "Resource": "arn:aws:s3:::${var.name}-cloudtrail"
      },
      {
        "Sid": "AWSCloudTrailWrite",
        "Effect": "Allow",
        "Principal": {
          "Service": "cloudtrail.amazonaws.com"
        },
        "Action": "s3:PutObject",
        "Resource": "arn:aws:s3:::${var.name}-cloudtrail/*",
        "Condition": {
          "StringEquals": {
            "s3:x-amz-acl": "bucket-owner-full-control"
          }
        }
      }
    ]
  }
  JSON

  tags = var.tags
}

