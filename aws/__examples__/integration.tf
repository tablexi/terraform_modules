module "vpc" {
  source = "../vpc"

  name = "vpc"
}

module "subnets" {
  source = "../vpc/subnets"

  name                = "subnets"
  vpc_id              = "${module.vpc.vpc_id}"
  internet_gateway_id = "${module.vpc.internet_gateway_id}"
}

module "trustor" {
  source = "../iam/crossaccount/trustor"

  trustee_account_name = "TableXI"
  trustee_account_arn  = "000000000000"
}

module "readonly_policy" {
  source = "../iam/policies/read_only"
}

module "trustor_readonly" {
  source = "../iam/crossaccount/trustor"

  trustee_account_name = "TXIReadOnly"
  trustee_account_arn  = "000000000000"
  access_policy        = "${module.readonly_policy.json}"
}

module "trustee" {
  source = "../iam/crossaccount/trustee"

  trustor_account_name = "Client"
  trustor_account_arn  = "1111111111111"
  trustee_account_name = "TableXI"
  trustee_group_name   = "Operations"
}

module "datadog" {
  source = "../iam/datadog"

  datadog_external_id = "123456789"
}

module "postgres" {
  source = "../rds"

  engine         = "postgres"
  engine_version = "9.6"
  name           = "test-postgres"
  subnets        = "${module.subnets.private_subnets}"
  vpc_id         = "${module.vpc.vpc_id}"
}

module "mysql" {
  source = "../rds"

  engine         = "mysql"
  name           = "test-mysql"
  subnets        = "${module.subnets.private_subnets}"
  engine_version = "5.7"
  vpc_id         = "${module.vpc.vpc_id}"
}

module "redis" {
  source = "../elasticache"

  engine         = "redis"
  engine_version = "3.2.4"
  name           = "redis"
  subnets        = "${module.subnets.private_subnets}"
  vpc_id         = "${module.vpc.vpc_id}"
}

module "memcached" {
  source = "../elasticache"

  engine         = "memcached"
  engine_version = "3.2.10"
  name           = "memcached"
  subnets        = "${module.subnets.private_subnets}"
  vpc_id         = "${module.vpc.vpc_id}"
}

module "ssh" {
  source = "../ec2/security_groups/ssh"

  vpc_id = "${module.vpc.vpc_id}"
}

module "ec2" {
  source = "../ec2"

  ami                    = "ami-0ff8a91507f77f867"
  key_name               = "ec2-key"
  name                   = "app"
  subnets                = "${module.subnets.public_subnets}"
  vpc_security_group_ids = ["${module.ssh.sg_id}"]
  vpc_id                 = "${module.vpc.vpc_id}"
}
