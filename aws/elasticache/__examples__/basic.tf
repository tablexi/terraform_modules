module "basic_redis" {
  source = "../"

  engine = "redis"
  engine_version = "2.8.17"
  name = "redis"
  subnets = ["redis"]
  vpc_id = "redis"
}
