resource "aws_iam_instance_profile" "mod" {
  name = var.name
  role = aws_iam_role.mod.name
}

resource "aws_iam_role" "mod" {
  assume_role_policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Action = "sts:AssumeRole"
          Principal = {
            Service = "ec2.amazonaws.com"
          }
          Effect = "Allow"
        },
      ]
    }
  )


  name = var.name
  path = "/"
}

resource "aws_iam_role_policy" "mod-ses-role-policy" {
  name  = "${var.name}-ses"
  count = var.ses ? 1 : 0

  policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Action = [
            "ses:SendRawEmail",
            "ses:SendEmail",
          ]
          Resource = "*"
        },
      ]
    }
  )

  role = aws_iam_role.mod.id
}

resource "aws_iam_role_policy" "mod-s3-role-policy" {
  name  = "${var.name}-s3"
  count = var.s3_bucket != "" ? 1 : 0

  policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Action = [
            "s3:ListAllMyBuckets",
          ]
          Effect   = "Allow"
          Resource = "arn:aws:s3:::*"
        },
        {
          Action = "s3:*"
          Effect = "Allow"
          Resource = [
            "arn:aws:s3:::${var.s3_bucket}",
            "arn:aws:s3:::${var.s3_bucket}/*",
          ]
        },
      ]
    }
  )

  role = aws_iam_role.mod.id
}

