module "ec2-test1" {
  source = "../"

  key_name = "ec2-test1"
  name = "ec2-test1"
  subnets = ["ec2-test1"]
  vpc_security_group_ids = ["ec2-test1"]
}
