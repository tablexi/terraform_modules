module "encrypted_redis" {
  source = "../"

  engine         = "redis"
  engine_version = "3.2.6"   # Cannot use 3.2.10 with encryption
  name           = "redis"
  subnets        = ["redis"]
  vpc_id         = "redis"

  at_rest_encryption_enabled = true
  transit_encryption_enabled = true
  force_replication_group    = true
}
