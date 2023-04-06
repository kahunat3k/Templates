# Brainboard auto-generated file.

resource "aws_vpc" "default" {
  tags       = merge(var.tags, {})
  cidr_block = var.vpc_cidr
}

resource "aws_flow_log" "default" {
  vpc_id = aws_vpc.default.id
  tags   = merge(var.tags, {})
}

