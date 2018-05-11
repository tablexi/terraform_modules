module "initech_production_load_balancer" {
  source = "../"

  environment = "production"
  name        = "initech"

  access_logs_enabled          = true
  certificate_arn              = "arn:aws:acm:us-east-1:123456789012:certificate/12345678-1234-1234-1234-123456789012"
  instances                    = ["i-09731747ba5296355", "i-0354a7616ba0dc1af"]
  instances_count              = 2
  security_group_for_instances = "sg-c94a8777"
  subnets                      = ["subnet-6fbdeeb3", "subnet-9ce530b1"]
  vpc_id                       = "vpc-eed63643"
}
