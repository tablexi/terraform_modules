module "rds-test1" {
  source = "../"

  engine = "postgres"
  name = "rds-test1"
  subnets = ["rds-test1"]
  version = "9.6"
  vpc_id = "rds-test1"
}
