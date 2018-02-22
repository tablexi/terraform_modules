module "rds-postgres" {
  source = "../"

  engine = "postgres"
  engine_version = "9.6"
  name = "rds-postgres"
  subnets = ["rds-postgres"]
  vpc_id = "rds-postgres"
}
