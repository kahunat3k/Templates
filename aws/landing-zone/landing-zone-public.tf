# Brainboard auto-generated file.

resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id
  tags   = merge(var.tags, {})
}

resource "aws_subnet" "public_a" {
  vpc_id            = aws_vpc.default.id
  tags              = merge(var.tags, {})
  cidr_block        = var.subnets.a
  availability_zone = "us-east-2a"
}

resource "aws_subnet" "public_b" {
  vpc_id            = aws_vpc.default.id
  tags              = merge(var.tags, {})
  cidr_block        = var.subnets.b
  availability_zone = "us-east-2b"
}

resource "aws_subnet" "public_c" {
  vpc_id            = aws_vpc.default.id
  tags              = merge(var.tags, {})
  cidr_block        = var.subnets.c
  availability_zone = "us-east-2c"
}

resource "aws_eip" "eip_a" {
  tags = merge(var.tags, {})
}

resource "aws_eip" "eip_b" {
  tags = merge(var.tags, {})
}

resource "aws_eip" "eip_c" {
  tags = merge(var.tags, {})
}

resource "aws_nat_gateway" "nat-gw-2b-public" {
  tags      = merge(var.tags, {})
  subnet_id = aws_subnet.public_b.id
}

resource "aws_nat_gateway" "nat-gw-2c-public" {
  tags      = merge(var.tags, {})
  subnet_id = aws_subnet.public_c.id
}

resource "aws_nat_gateway" "nat-gw-2a-public" {
  tags      = merge(var.tags, {})
  subnet_id = aws_subnet.public_a.id
}

resource "aws_route_table" "rt_public_b" {
  vpc_id = aws_vpc.default.id
  tags   = merge(var.tags, {})
}

resource "aws_route_table" "rt_public_c" {
  vpc_id = aws_vpc.default.id
  tags   = merge(var.tags, {})
}

resource "aws_route_table" "rt_public_a" {
  vpc_id = aws_vpc.default.id
}

