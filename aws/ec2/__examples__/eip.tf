module "with-eip" {
  source = "../"

  enable_eip = true
  key_name = "without-ami"
  name = "without-ami"
  subnets = ["without-ami"]
  vpc_id = "vpc_abc123"
}
