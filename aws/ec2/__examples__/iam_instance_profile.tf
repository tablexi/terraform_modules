resource "aws_iam_instance_profile" "with-iam-instance-profile" {
  name = "with-iam-instance-profile"
}

module "with-iam-instance-profile" {
  source = "../"

  ami                  = "ami-0ff8a91507f77f867"
  iam_instance_profile = "${aws_iam_instance_profile.with-iam-instance-profile.arn}"
  key_name             = "without-ami"
  name                 = "without-ami"
  subnets              = ["without-ami"]
  vpc_id               = "vpc_abc123"
}
