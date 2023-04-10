# Brainboard auto-generated file.

resource "aws_route_table" "rt_private_b" {
  vpc_id = aws_vpc.default.id
  tags   = merge(var.tags, {})
}

resource "aws_route_table" "rt_private_a" {
  vpc_id = aws_vpc.default.id
  tags   = merge(var.tags, {})
}

resource "aws_route_table" "rt_private_c" {
  vpc_id = aws_vpc.default.id
  tags   = merge(var.tags, {})
}

resource "aws_subnet" "private_b" {
  vpc_id                  = aws_vpc.default.id
  tags                    = merge(var.tags, {})
  map_public_ip_on_launch = false
  cidr_block              = var.private_subnets.b
  availability_zone       = "us-east-2b"
}

resource "aws_subnet" "private_a" {
  vpc_id                  = aws_vpc.default.id
  tags                    = merge(var.tags, {})
  map_public_ip_on_launch = false
  cidr_block              = var.private_subnets.a
  availability_zone       = "us-east-2a"
}

resource "aws_subnet" "private_c" {
  vpc_id                  = aws_vpc.default.id
  tags                    = merge(var.tags, {})
  map_public_ip_on_launch = false
  cidr_block              = var.private_subnets.c
  availability_zone       = "us-east-2c"
}

