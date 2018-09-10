module "rds-mysql" {
  source = "../"

  engine         = "mysql"
  engine_version = "5.7"
  name           = "rds-mysql"
  subnets        = ["rds-mysql"]
  vpc_id         = "rds-mysql"
}
