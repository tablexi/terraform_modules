module "vpc_test1" {
  source = "../../"

  name = "vpc_test1"
}

module "subnets_test1" {
  source = "../"

  name = "subnets_test1"
  vpc_id = "${module.vpc_test1.vpc_id}"
  internet_gateway_id = "${module.vpc_test1.internet_gateway_id}"
}
