data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    sid = ""
    actions = [
      "sts:AssumeRole",
    ]
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam:::root",
      ]
    }
  }
}

module "assume_role_policy" {
  source = "../"

  assume_role_policy = "${data.aws_iam_policy_document.assume_role_policy.json}"
  trustee_account_name = "TableXI"
  trustee_account_arn = "000000000000"
}
