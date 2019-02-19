resource "aws_vpc" "mod" {
  cidr_block           = "${var.cidr}"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = "${var.tags}"
}

resource "aws_internet_gateway" "mod" {
  tags   = "${var.tags}"
  vpc_id = "${aws_vpc.mod.id}"
}
