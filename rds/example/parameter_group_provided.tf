module "rds-parameter-group-provided" {
  source = "../"

  engine = "postgres"
  name = "rds-parameter-group-provided"
  parameter_group_name = "${aws_db_parameter_group.parameter-group-provided.id}"
  parameter_group_provided = true
  subnets = ["rds-parameter-group-provided"]
  version = "9.6"
  vpc_id = "rds-parameter-group-provided"
}

resource "aws_db_parameter_group" "parameter-group-provided" {
  name = "parameter-group-provided"
  family = "parameter-group-provided"
  description = "parameter-group-provided"
}
