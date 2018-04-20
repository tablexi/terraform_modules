module "without-ami" {
  source = "../"

  key_name = "without-ami"
  name = "without-ami"
  subnets = ["without-ami"]
  vpc_id = "vpc_abc123"
}

module "with-ami" {
  source = "../"

  ami = "with-ami"
  key_name = "with-ami"
  name = "with-ami"
  subnets = ["with-ami"]
  vpc_id = "vpc_abc123"
}
