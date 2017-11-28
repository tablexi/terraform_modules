module "without-ami" {
  source = "../"

  key_name = "without-ami"
  name = "without-ami"
  subnets = ["without-ami"]
}

module "with-ami" {
  source = "../"

  ami = "with-ami"
  key_name = "with-ami"
  name = "with-ami"
  subnets = ["with-ami"]
}
