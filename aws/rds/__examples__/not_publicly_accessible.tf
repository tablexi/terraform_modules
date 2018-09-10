module "not_publicly_accessible" {
  source = "../"

  engine              = "postgres"
  engine_version      = "9.6"
  name                = "not-publicly-accessible"
  publicly_accessible = false
  subnets             = ["rds-postgres"]
  vpc_id              = "rds-postgres"
}
