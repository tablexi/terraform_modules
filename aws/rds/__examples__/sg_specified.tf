module "sg-spec-postgres" {
  source = "../"

  engine                 = "postgres"
  engine_version         = "9.6"
  name                   = "sg-spec-postgres"
  subnets                = ["sg-spec-postgres"]
  storage_encrypted      = true
  vpc_id                 = "sg-spec-postgres"
  vpc_security_group_ids = ["${aws_security_group.specified_sg.id}"]
}

resource "aws_security_group" "specified_sg" {
  name   = "good_security_group"
  vpc_id = "sg-spec-postgres"
}
