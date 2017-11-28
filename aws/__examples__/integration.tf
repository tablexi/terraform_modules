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

module "postgres" {
  source = "../rds"

  engine = "postgres"
  name = "test-postgres"
  subnets = "${module.subnets.private_subnets}"
  version = "9.6"
  vpc_id = "${module.vpc.vpc_id}"
}

module "mysql" {
  source = "../rds"

  engine = "mysql"
  name = "test-mysql"
  subnets = "${module.subnets.private_subnets}"
  version = "5.7"
  vpc_id = "${module.vpc.vpc_id}"
}

module "redis" {
  source = "../elasticache"

  engine = "redis"
  name = "redis"
  subnets = "${module.subnets.private_subnets}"
  version = "3.2.4"
  vpc_id = "${module.vpc.vpc_id}"
}

module "memcached" {
  source = "../elasticache"

  engine = "memcached"
  name = "memcached"
  subnets = "${module.subnets.private_subnets}"
  version = "3.2.10"
  vpc_id = "${module.vpc.vpc_id}"
}

module "ec2" {
  source = "../ec2"

  key_name = "ec2-key"
  name = "app"
  subnets = "${module.subnets.public_subnets}"
}
