module "alb" {
  source = "../"

  name = "alb"
  env = "prod"
  subnets = ["alb"]
  type = "application"
  vpc_id = "alb"
}
