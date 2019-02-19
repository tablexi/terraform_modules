resource "aws_vpc" "mod" {
  cidr_block           = "${var.cidr}"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name                    = "${var.name}"
    "txi:client"            = "${var.client}"
    "txi:infra_environment" = "${var.infra_environment}"
  }
}

resource "aws_internet_gateway" "mod" {
  vpc_id = "${aws_vpc.mod.id}"

  tags = {
    Name                    = "${var.name}"
    "txi:client"            = "${var.client}"
    "txi:infra_environment" = "${var.infra_environment}"
  }
}
