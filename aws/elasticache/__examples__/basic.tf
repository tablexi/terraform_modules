module "basic_redis" {
  source = "../"

  engine = "redis"
  engine_version = "2.8.17"
  name = "redis"
  security_groups_for_ingress = ["sg_ec1234"]
  subnets = ["redis"]
  vpc_id = "redis"
}
