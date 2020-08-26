resource "aws_iam_policy" "mod" {
  name = "S3${var.name}${var.env}Access"

  policy = jsonencode(
    {
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
            "arn:aws:s3:::${var.bucket_id}",
            "arn:aws:s3:::${var.bucket_id}/*",
          ]
        },
      ]
      Version = "2012-10-17"
    }
  )

}

resource "aws_iam_policy_attachment" "mod" {
  name       = "s3-${var.name}-${var.env}-access"
  users      = var.users
  roles      = var.roles
  policy_arn = aws_iam_policy.mod.arn
}
