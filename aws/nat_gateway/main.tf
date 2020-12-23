# Create a single subnet for the NAT Gateway to live in
# routed to the outside world

data "aws_vpc" "current" {
  id = var.vpc_id
}

# Create a subnet in us-east-1a in the
# CIDR block specified by the inputs
# So that the CIDR block is different than
# others in this VPC
resource "aws_subnet" "mod" {
  count             = var.uses_nat_gateway ? 1 : 0
  availability_zone = var.availability_zone
  cidr_block = cidrsubnet(
    data.aws_vpc.current.cidr_block,
    var.subnet_cidr_newbits,
    var.subnet_cidr_netnum_offset + 1,
  )
  map_public_ip_on_launch = true
  tags                    = var.tags
  vpc_id                  = var.vpc_id
}


# ElasticIP address for use with the NAT Gateway
resource "aws_eip" "nat-gw-eip" {
  count = var.uses_nat_gateway ? 1 : 0
  vpc   = true
  tags  = var.tags
}

# NAT Gateway in the first (only) subnet
resource "aws_nat_gateway" "gw" {
  count         = var.uses_nat_gateway ? 1 : 0
  allocation_id = aws_eip.nat-gw-eip[0].id
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
  count  = var.uses_nat_gateway ? 1 : 0
  tags   = var.tags
  vpc_id = var.vpc_id
}

resource "aws_route" "mod" {
  count                  = var.uses_nat_gateway ? 1 : 0
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.gw[0].id
  route_table_id         = aws_route_table.mod[0].id
}

resource "aws_route_table_association" "mod" {
  count          = var.uses_nat_gateway ? 1 : 0
  route_table_id = aws_route_table.mod[0].id
  subnet_id      = aws_subnet.mod[0].id
}
