module "test1" {
  source = "../"

  engine = "postgres"
  name = "test1"
  subnets = ["test1"]
  version = "9.6"
  vpc_id = "test1"
}
