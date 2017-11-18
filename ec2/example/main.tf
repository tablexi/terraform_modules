module "ec2-test1" {
  source = "../"

  key_name = "ec2-test1"
  name = "ec2-test1"
  subnets = ["ec2-test1"]
  vpc_security_group_ids = ["ec2-test1"]
}

module "ec2-test2" {
  source = "../"

  ami = "ec2-test2"
  key_name = "ec2-test2"
  name = "ec2-test2"
  subnets = ["ec2-test2"]
  vpc_security_group_ids = ["ec2-test2"]
}
