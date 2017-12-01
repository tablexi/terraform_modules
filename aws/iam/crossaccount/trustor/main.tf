data "aws_iam_policy_document" "mod" {
  count = "${var.assume_role_policy == "" ? 1 : 0}"

  statement {
    sid = ""
    actions = [
      "sts:AssumeRole",
    ]
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${var.trustee_account_arn}:root",
      ]
    }
  }
}

resource "aws_iam_role" "mod" {
  name = "${var.trustee_account_name}CrossAccountAccessRole"
  assume_role_policy = "${var.assume_role_policy == "" ? data.aws_iam_policy_document.mod.json : var.assume_role_policy}"
}

resource "aws_iam_policy" "mod" {
  name = "${var.trustee_account_name}CrossAccountAdminAccess"
  path = "/"
  description = "${var.trustee_account_name} full access policy with delete provisions for cross account access."
  policy = "${var.access_policy}"
}

resource "aws_iam_policy_attachment" "mod" {
  name = "${var.trustee_account_name}CrossAccountAdminAccess"
  roles = ["${aws_iam_role.mod.name}"]
  policy_arn = "${aws_iam_policy.mod.arn}"
}
