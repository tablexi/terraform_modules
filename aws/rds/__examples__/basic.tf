module "rds-postgres" {
  source = "../"

  engine = "postgres"
  name = "rds-postgres"
  subnets = ["rds-postgres"]
  version = "9.6"
  vpc_id = "rds-postgres"
}
