module "rds-mysql" {
  source = "../"

  engine = "mysql"
  name = "rds-mysql"
  subnets = ["rds-mysql"]
  version = "5.7"
  vpc_id = "rds-mysql"
}
