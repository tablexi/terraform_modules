module "alb" {
  source = "../"

  name = "alb"
  env = "prod"
  type = "application"
  vpc_id = "alb"
}
