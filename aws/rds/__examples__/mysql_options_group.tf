module "rds-mysql-option-group" {
  source = "../"

  engine = "mysql"
  option_group_provided = true
  option_group_name = "${aws_db_option_group.rds-mysql-option-group.id}"
  name = "rds-mysql-option-group"
  subnets = ["rds-mysql-option-group"]
  engine_version = "5.7"
  vpc_id = "rds-mysql-option-group"
}

resource "aws_db_option_group" "rds-mysql-option-group" {
  name = "rds-mysql-option-group"
  engine_name = "rds-mysql-option-group"
  major_engine_version = "rds-mysql-option-group"
}

