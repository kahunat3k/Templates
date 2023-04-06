# Brainboard auto-generated file.

resource "aws_subnet" "public-subnet-b" {
  vpc_id            = aws_vpc.default_vpc.id
  cidr_block        = var.public_subnet_cidr
  availability_zone = "eu-west-3a"

  tags = {
    Name = "public subnet B"
  }
}

resource "aws_internet_gateway" "default_internet_gateway" {
  vpc_id = aws_vpc.default_vpc.id
}

resource "aws_network_acl" "public_network_acl_a" {
  vpc_id = aws_vpc.default_vpc.id

  subnet_ids = [
    aws_subnet.public-subnet-a.id,
  ]

  tags = {
    Name = "public net ACL A"
  }
}

resource "aws_subnet" "public-subnet-a" {
  vpc_id            = aws_vpc.default_vpc.id
  cidr_block        = var.public_subnet_cidr
  availability_zone = "eu-west-3a"

  tags = {
    Name = "public subnet A"
  }
}

resource "aws_security_group" "private-sg-b" {
  vpc_id = aws_vpc.default_vpc.id

  tags = {
    Name = "private SG B"
  }
}

resource "aws_route_table_association" "route_table_association_a" {
  subnet_id      = aws_subnet.public-subnet-a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "route_table_association_b" {
  subnet_id      = aws_subnet.public-subnet-b.id
  route_table_id = aws_route_table.public.id
}

resource "aws_nat_gateway" "public_nat_gateway_b" {
  subnet_id     = aws_subnet.public-subnet-b.id
  allocation_id = aws_eip.nat_b.id

  tags = {
    Name = "public nat gtw B"
  }
}

resource "aws_security_group" "private-sg-a" {
  vpc_id = aws_vpc.default_vpc.id

  tags = {
    Name = "private SG A"
  }
}

resource "aws_subnet" "private-subnet-a" {
  vpc_id            = aws_vpc.default_vpc.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = "eu-west-3b"

  tags = {
    Name = "private subnet A"
  }
}

resource "aws_subnet" "private-subnet-b" {
  vpc_id            = aws_vpc.default_vpc.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = "eu-west-3b"

  tags = {
    Name = "private subnet B"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.default_vpc.id

  route {
    gateway_id = aws_internet_gateway.default_internet_gateway.id
    cidr_block = "0.0.0.0/0"
  }

  tags = {
    Name = "rt-public"
  }
}

resource "aws_nat_gateway" "public_nat_gateway_a" {
  subnet_id     = aws_subnet.public-subnet-a.id
  allocation_id = aws_eip.nat_a.id

  tags = {
    Name = "public nat gtw A"
  }
}

resource "aws_vpc" "default_vpc" {
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  cidr_block           = var.vpc_cidr_block

  tags = {
    Name = "default VPC"
  }
}

resource "aws_network_acl" "public_network_acl_b" {
  vpc_id = aws_vpc.default_vpc.id

  subnet_ids = [
    aws_subnet.public-subnet-b.id,
  ]

  tags = {
    Name = "public net ACL B"
  }
}

resource "aws_eip" "nat_b" {

  tags = {
    Name = "EIP NAT B"
  }
}

resource "aws_eip" "nat_a" {

  tags = {
    Name = "EIP NAT A"
  }
}

