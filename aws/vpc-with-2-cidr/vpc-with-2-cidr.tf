# Brainboard auto-generated file.

resource "aws_vpc" "vpc_1" {
  cidr_block = "10.0.1.0/24"

  tags = {
    env      = "Development"
    archUUID = "5ec287aa-f2b1-430c-832e-0933ce2dc0de"
  }
}

resource "aws_vpc_ipv4_cidr_block_association" "vpc_ipv4_cidr_block_association_2" {
  vpc_id     = aws_vpc.vpc_1.id
  cidr_block = "10.0.2.0/24"
}

