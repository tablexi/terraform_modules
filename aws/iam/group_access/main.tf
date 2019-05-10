resource "aws_iam_group" "mod" {
  name = "${var.name}"
}

resource "aws_iam_group_membership" "mod" {
  name  = "${var.name}-group-membership"
  users = ["${var.users}"]
  group = "${aws_iam_group.mod.name}"
}

resource "aws_iam_group_policy_attachment" "mod" {
  group      = "${aws_iam_group.mod.name}"
  policy_arn = "${var.policy_arn}"
}
