module "external_security_group_access" {
  source = "../"

  engine = "redis"
  engine_version = "2.8.17"
  name = "redis"
  sg_for_access_ids = ["redis"]
  subnets = ["redis"]
  vpc_id = "redis"
}

module "external_without_internal_sg" {
  source = "../"

  engine = "redis"
  engine_version = "2.8.17"
  name = "redis"
  provide_sg_for_access = false
  sg_for_access_ids = ["redis"]
  subnets = ["redis"]
  vpc_id = "redis"
}
