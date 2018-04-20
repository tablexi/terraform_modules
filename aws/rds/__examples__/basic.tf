module "rds-postgres" {
  source = "../"

  engine = "postgres"
  engine_version = "9.6"
  name = "rds-postgres"
  security_groups_for_ingress = ["sg_defg4567"]
  subnets = ["rds-postgres"]
  vpc_id = "rds-postgres"
}
