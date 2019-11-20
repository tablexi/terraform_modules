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

  policy = jsonencode(
    {
      Statement = [
        {
          Action = "s3:GetBucketAcl"
          Effect = "Allow"
          Principal = {
            Service = "cloudtrail.amazonaws.com"
          }
          Resource = "arn:aws:s3:::${var.name}-cloudtrail"
          Sid = "AWSCloudTrailAclCheck"
        },
        {
          Action = "s3:PutObject"
          Condition = {
            StringEquals = {
              "s3:x-amz-acl" = "bucket-owner-full-control"
            }
          }
          Effect = "Allow"
          Principal = {
            Service = "cloudtrail.amazonaws.com"
          }
          Resource = "arn:aws:s3:::${var.name}-cloudtrail/*"
          Sid = "AWSCloudTrailWrite"
        },
      ]
      Version = "2012-10-17"
    }
  )

  tags = var.tags
}

