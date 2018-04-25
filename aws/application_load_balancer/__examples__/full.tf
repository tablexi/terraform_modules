module "globex_production_load_balancer" {
  source = "../"

  environment = "production"
  name        = "globex"

  certificate_arn              = "arn:aws:acm:us-east-1:210987654321:certificate/87654321-4321-4321-4321-210987654321"
  health_check_path            = "/health_check"
  instances                    = ["i-088348c7b2bd8ebfd", "i-04711668341adedf1"]
  instances_count              = 2
  internal                     = true
  security_group_for_instances = "sg-264269ad"
  ssl_policy                   = "ELBSecurityPolicy-TLS-1-0-2015-04"
  subnets                      = ["subnet-e3f4a330", "subnet-9b6635ea"]
  vpc_id                       = "vpc-e365d769"
}
