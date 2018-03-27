module "vpc" {
  source = "../vpc"

  name = "vpc"
}

module "subnets" {
  source = "../vpc/subnets"

  name = "subnets"
  vpc_id = "${module.vpc.vpc_id}"
  internet_gateway_id = "${module.vpc.internet_gateway_id}"
}

module "trustor" {
  source = "../iam/crossaccount/trustor"

  trustee_account_name = "TableXI"
  trustee_account_arn = "000000000000"
}

module "readonly_policy" {
  source = "../iam/policies/read_only"
}

module "trustor_readonly" {
  source = "../iam/crossaccount/trustor"

  trustee_account_name = "TXIReadOnly"
  trustee_account_arn = "000000000000"
  access_policy = "${module.readonly_policy.json}"
}

module "trustee" {
  source = "../iam/crossaccount/trustee"

  trustor_account_name = "Client"
  trustor_account_arn = "1111111111111"
  trustee_account_name = "TableXI"
  trustee_group_name = "Operations"
}

module "datadog" {
  source = "../iam/datadog"

  datadog_external_id = "123456789"
}

module "postgres" {
  source = "../rds"

  engine = "postgres"
  engine_version = "9.6"
  name = "test-postgres"
  subnets = "${module.subnets.private_subnets}"
  vpc_id = "${module.vpc.vpc_id}"
}

module "mysql" {
  source = "../rds"

  engine = "mysql"
  name = "test-mysql"
  subnets = "${module.subnets.private_subnets}"
  engine_version = "5.7"
  vpc_id = "${module.vpc.vpc_id}"
}

module "redis" {
  source = "../elasticache"

  engine = "redis"
  engine_version = "3.2.4"
  name = "redis"
  subnets = "${module.subnets.private_subnets}"
  vpc_id = "${module.vpc.vpc_id}"
}

module "memcached" {
  source = "../elasticache"

  engine = "memcached"
  engine_version = "3.2.10"
  name = "memcached"
  subnets = "${module.subnets.private_subnets}"
  vpc_id = "${module.vpc.vpc_id}"
}

module "ssh" {
  source = "../ec2/security_groups/ssh"

  vpc_id = "${module.vpc.vpc_id}"
}

module "ec2" {
  source = "../ec2"

  key_name = "ec2-key"
  name = "app"
  subnets = "${module.subnets.public_subnets}"
  vpc_security_group_ids = ["${module.ssh.sg_id}"]
}

module "alb" {
  source = "../ec2/load_balancers/lb"

  name = "alb"
  env = "prod"
  subnets = ["${module.subnets.public_subnets}"]
  type = "application"
  vpc_id = "${module.vpc.vpc_id}"
}

module "http_target_listener" {
  source = "../ec2/load_balancers/lb/target_listener"
  sg_on_lb_id = "${module.alb.sg_on_lb_id}"
  sg_for_access_by_sgs_id = "${module.alb.sg_for_access_by_sgs_id}"
  lb_arn = "${module.alb.lb_arn}"
  name = "http"
  port = 80
  protocol = "HTTP"
  target_id_count = 2
  target_ids = "${module.ec2.instance_ids}"
  vpc_id = "${module.vpc.vpc_id}"
}
