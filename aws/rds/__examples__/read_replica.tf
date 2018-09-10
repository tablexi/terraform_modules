module "read-replica" {
  source = "../"

  engine         = "postgres"
  engine_version = "9.6"
  name           = "rds-postgres"
  subnets        = ["rds-postgres"]
  vpc_id         = "rds-postgres"
  source_db      = "primary-db-id"
}
