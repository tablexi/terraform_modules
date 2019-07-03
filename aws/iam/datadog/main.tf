resource "aws_iam_policy" "mod" {
  name        = var.datadog_policy_name
  description = var.datadog_policy_name
  path        = "/"

  policy = jsonencode(
    {
      Statement = [
        {
          Action = [
            "autoscaling:Describe*",
            "budgets:ViewBudget",
            "cloudfront:GetDistributionConfig",
            "cloudfront:ListDistributions",
            "cloudtrail:DescribeTrails",
            "cloudtrail:GetTrailStatus",
            "cloudwatch:Describe*",
            "cloudwatch:Get*",
            "cloudwatch:List*",
            "codedeploy:List*",
            "codedeploy:BatchGet*",
            "directconnect:Describe*",
            "dynamodb:List*",
            "dynamodb:Describe*",
            "ec2:Describe*",
            "ecs:Describe*",
            "ecs:List*",
            "elasticache:Describe*",
            "elasticache:List*",
            "elasticfilesystem:DescribeFileSystems",
            "elasticfilesystem:DescribeTags",
            "elasticloadbalancing:Describe*",
            "elasticmapreduce:List*",
            "elasticmapreduce:Describe*",
            "es:ListTags",
            "es:ListDomainNames",
            "es:DescribeElasticsearchDomains",
            "health:DescribeEvents",
            "health:DescribeEventDetails",
            "health:DescribeAffectedEntities",
            "kinesis:List*",
            "kinesis:Describe*",
            "lambda:AddPermission",
            "lambda:GetPolicy",
            "lambda:List*",
            "lambda:RemovePermission",
            "logs:Get*",
            "logs:Describe*",
            "logs:FilterLogEvents",
            "logs:TestMetricFilter",
            "rds:Describe*",
            "rds:List*",
            "redshift:DescribeClusters",
            "redshift:DescribeLoggingStatus",
            "route53:List*",
            "s3:GetBucketLogging",
            "s3:GetBucketLocation",
            "s3:GetBucketNotification",
            "s3:GetBucketTagging",
            "s3:ListAllMyBuckets",
            "s3:PutBucketNotification",
            "ses:Get*",
            "sns:List*",
            "sns:Publish",
            "sqs:ListQueues",
            "support:*",
            "tag:getResources",
            "tag:getTagKeys",
            "tag:getTagValues",
          ]
          Effect   = "Allow"
          Resource = "*"
        },
      ]
      Version = "2012-10-17"
    }
  )
}

resource "aws_iam_role" "mod" {
  name = var.datadog_role_name

  assume_role_policy = jsonencode(
    {
      Statement = {
        Action = "sts:AssumeRole"
        Condition = {
          StringEquals = {
            sts:ExternalId = "${var.datadog_external_id}"
          }
        }
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::464622532012:root"
        }
      }
      Version = "2012-10-17"
    }
  )
}

resource "aws_iam_policy_attachment" "mod" {
  name       = "Allow Datadog PolicyAccess via Role"
  policy_arn = aws_iam_policy.mod.arn
  roles      = [aws_iam_role.mod.name]
}

