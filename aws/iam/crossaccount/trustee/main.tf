resource "aws_iam_group_policy" "mod" {
  name  = "${var.trustor_account_name}CrossAccountPolicy"
  group = var.trustee_group_name

  policy = jsonencode(
    {
      Statement = {
        Action   = "sts:AssumeRole"
        Effect   = "Allow"
        Resource = "arn:aws:iam::${var.trustor_account_arn}:role/${var.trustee_account_name}CrossAccountAccessRole"
      }
      Version = "2012-10-17"
    }
  )

}

