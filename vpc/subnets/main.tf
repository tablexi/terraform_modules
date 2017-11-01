# Find the available availability zones
data "aws_availability_zones" "available" {}

locals {
  default_az_to_netnum = {
    a = 1
    b = 2
    c = 3
    d = 4
    e = 5
    f = 6
  }
}

data "template_file" "az_to_netnum" {
  count = "${length(data.aws_availability_zones.available.names)}"
  template = "$${netnum}"

  vars {
    netnum = "${lookup(local.default_az_to_netnum, substr(element(data.aws_availability_zones.available.names, count.index), -1, 1))}"
  }
}

# Sets up the public subnet's route table
resource "aws_route_table" "mod_public" {
  vpc_id = "${var.vpc_id}"
  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = "${var.internet_gateway_id}"
  }
  tags { Name = "${var.environment_name}-public" }
}

# Sets up the private subnet's route table
# Send all traffic over the nat gateway
resource "aws_route_table" "mod_private" {
  vpc_id = "${var.vpc_id}"
  tags { Name = "${var.environment_name}-private" }
}

# Sets up the private subnets
resource "aws_subnet" "mod_private" {
  vpc_id = "${var.vpc_id}"
  cidr_block = "${cidrsubnet(var.vpc_cidr_block, var.private_newbits, var.private_netnum_offset + element(data.template_file.az_to_netnum.*.rendered, count.index))}"
  availability_zone = "${element(data.aws_availability_zones.available.names, count.index)}"
  count = "${length(data.aws_availability_zones.available.names)}"
  tags { Name = "${var.environment_name}-${element(data.aws_availability_zones.available.names, count.index)}-private" }
}

# Sets up the public subnets
resource "aws_subnet" "mod_public" {
  vpc_id = "${var.vpc_id}"
  cidr_block = "${cidrsubnet(var.vpc_cidr_block, var.public_newbits, var.public_netnum_offset + element(data.template_file.az_to_netnum.*.rendered, count.index))}"
  availability_zone = "${element(data.aws_availability_zones.available.names, count.index)}"
  count = "${length(data.aws_availability_zones.available.names)}"
  tags { Name = "${var.environment_name}-${element(data.aws_availability_zones.available.names, count.index)}-public" }

  map_public_ip_on_launch = true
}

# Sets up as association between the private subnet and private route table
resource "aws_route_table_association" "mod_private" {
  count = "${length(data.aws_availability_zones.available.names)}"
  subnet_id = "${element(aws_subnet.mod_private.*.id, count.index)}"
  route_table_id = "${aws_route_table.mod_private.id}"
}

# Sets up as association between the public subnet and public route table
resource "aws_route_table_association" "mod_public" {
  count = "${length(data.aws_availability_zones.available.names)}"
  subnet_id = "${element(aws_subnet.mod_public.*.id, count.index)}"
  route_table_id = "${aws_route_table.mod_public.id}"
}
