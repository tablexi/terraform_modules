# Find the available availability zones
data "aws_availability_zones" "available" {
}

data "aws_vpc" "current" {
  id = var.vpc_id
}

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
  count    = length(data.aws_availability_zones.available.names)
  template = "$${netnum}"

  vars = {
    netnum = local.default_az_to_netnum[substr(
      element(data.aws_availability_zones.available.names, count.index),
      -1,
      1,
    )]
  }
}

resource "aws_route_table" "mod" {
  tags   = var.tags
  vpc_id = var.vpc_id
}

resource "aws_route" "mod" {
  count                  = var.public ? 1 : 0
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = var.internet_gateway_id
  route_table_id         = aws_route_table.mod.id
}

resource "aws_subnet" "mod" {
  count             = length(data.aws_availability_zones.available.names)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
  cidr_block = cidrsubnet(
    data.aws_vpc.current.cidr_block,
    var.newbits,
    var.netnum_offset + element(data.template_file.az_to_netnum[*].rendered, count.index),
  )
  map_public_ip_on_launch = var.public
  tags                    = var.tags
  vpc_id                  = var.vpc_id
}

resource "aws_route_table_association" "mod" {
  count          = length(data.aws_availability_zones.available.names)
  route_table_id = aws_route_table.mod.id
  subnet_id      = element(aws_subnet.mod[*].id, count.index)
}

