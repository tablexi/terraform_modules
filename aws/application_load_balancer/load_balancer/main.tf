locals {
  # https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-access-logs.html#access-logging-bucket-permissions
  elastic_load_balancing_account_ids = {
    ap-northeast-1 = "582318560864"
    ap-northeast-2 = "600734575887"
    ap-northeast-3 = "383597477331"
    ap-south-1     = "718504428378"
    ap-southeast-1 = "114774131450"
    ap-southeast-2 = "783225319266"
    ca-central-1   = "985666609251"
    eu-central-1   = "054676820928"
    eu-west-1      = "156460612806"
    eu-west-2      = "652711504416"
    eu-west-3      = "009996457667"
    sa-east-1      = "507241528517"
    us-east-1      = "127311923021"
    us-east-2      = "033677994240"
    us-west-1      = "027434742980"
    us-west-2      = "797873946194"
  }

  access_logs_glacier_transition_days = 365
}

resource "aws_alb" "load_balancer" {
  count           = var.access_logs_enabled ? 0 : 1
  name            = var.name
  internal        = var.internal
  security_groups = var.security_groups
  subnets         = var.subnets

  tags = var.tags
}

resource "aws_alb" "load_balancer_with_access_logs" {
  count           = var.access_logs_enabled ? 1 : 0
  name            = var.name
  internal        = var.internal
  security_groups = var.security_groups
  subnets         = var.subnets

  access_logs {
    bucket  = aws_s3_bucket.load_balancer_access_logs[0].id
    enabled = true
  }

  tags = var.tags
}

data "aws_caller_identity" "aws_account" {
  count = var.access_logs_enabled ? 1 : 0
}

resource "aws_s3_bucket" "load_balancer_access_logs" {
  bucket = "${var.name}-logs"
  count  = var.access_logs_enabled ? 1 : 0

  lifecycle_rule {
    enabled = true

    transition {
      days          = local.access_logs_glacier_transition_days
      storage_class = "GLACIER"
    }
  }

  tags = var.tags
}

resource "aws_s3_bucket_policy" "load_balancer_access_logs" {
  bucket = aws_s3_bucket.load_balancer_access_logs[0].id
  count  = var.access_logs_enabled ? 1 : 0

  policy = <<-JSON
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": [
            "s3:PutObject"
          ],
          "Effect": "Allow",
          "Resource": "${aws_s3_bucket.load_balancer_access_logs[0].arn}/AWSLogs/${data.aws_caller_identity.aws_account[0].account_id}/*",
          "Principal": {
            "AWS": [
              "arn:aws:iam::${local.elastic_load_balancing_account_ids[aws_s3_bucket.load_balancer_access_logs[0].region]}:root"
            ]
          }
        }
      ]
    }
JSON

}

