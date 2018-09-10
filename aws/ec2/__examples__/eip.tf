module "with-eip" {
  source = "../"

  ami        = "ami-0ff8a91507f77f867"
  enable_eip = true
  key_name   = "without-ami"
  name       = "without-ami"
  subnets    = ["without-ami"]
  vpc_id     = "vpc_abc123"
}
