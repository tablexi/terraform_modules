module "read_only" {
  source = "../"
}

resource "aws_iam_policy" "read_only" {
  policy = "${module.read_only.json}"
}
