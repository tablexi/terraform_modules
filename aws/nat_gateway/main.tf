locals {
  subnet_tags = merge(var.tags, { "kubernetes.io/role/elb" = true })
}

# Create subnets for use by the LoadBalancer for ingress
# And use the first of these subnets for the NAT Gateway

data "aws_availability_zones" "available" {
  exclude_names = var.exclude_availability_zones
}

data "aws_vpc" "current" {
  id = var.vpc_id
}

resource "aws_subnet" "mod" {
  count             = length(data.aws_availability_zones.available.names)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
  cidr_block = cidrsubnet(
    data.aws_vpc.current.cidr_block,
    var.subnet_cidr_newbits,
    var.subnet_cidr_netnum_offset + count.index + 1,
  )
  map_public_ip_on_launch = true
  tags                    = local.subnet_tags
  vpc_id                  = var.vpc_id
}

# ElasticIP address for use with the NAT Gateway
resource "aws_eip" "nat-gw-eip" {
  vpc  = true
  tags = var.tags
}

# NAT Gateway in the first subnet
resource "aws_nat_gateway" "gw" {
  allocation_id = aws_eip.nat-gw-eip.id
  subnet_id     = aws_subnet.mod[0].id

  tags = merge(
    var.tags,
    {
      Name = var.name
    },
  )
  depends_on = [var.internet_gateway_id]
}

resource "aws_route_table" "mod" {
  tags   = var.tags
  vpc_id = var.vpc_id
}

resource "aws_route" "mod" {
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = var.internet_gateway_id
  route_table_id         = aws_route_table.mod.id
}

resource "aws_route_table_association" "mod" {
  count          = length(data.aws_availability_zones.available.names)
  route_table_id = aws_route_table.mod.id
  subnet_id      = element(aws_subnet.mod[*].id, count.index)
}
