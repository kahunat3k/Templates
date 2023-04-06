# Brainboard auto-generated file.

resource "aws_security_group" "administration" {
  vpc_id      = aws_vpc.terraform.id
  name        = "administration"
  description = "Allow default administration service"

  tags = {
    Name = "administration"
  }
}

resource "aws_vpc" "terraform" {
  enable_dns_hostnames = true
  cidr_block           = var.vpc_cidr

  tags = {
    Name = "vpc-http"
  }
}

resource "aws_key_pair" "user_key" {
  public_key = var.public_key
}

resource "aws_subnet" "http" {
  vpc_id     = aws_vpc.terraform.id
  cidr_block = var.network_http["cidr"]

  depends_on = [
    aws_internet_gateway.gw,
  ]

  tags = {
    Name = "subnet-http"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.terraform.id

  tags = {
    Name = "internet-gateway"
  }
}

resource "aws_subnet" "db" {
  vpc_id     = aws_vpc.terraform.id
  cidr_block = var.network_db["cidr"]

  depends_on = [
    aws_internet_gateway.gw,
  ]

  tags = {
    Name = "subnet-db"
  }
}

resource "aws_security_group_rule" "db_port" {
  type              = "ingress"
  to_port           = 3306
  security_group_id = aws_security_group.web.id
  protocol          = "tcp"
  from_port         = 3306

  cidr_blocks = [
    "0.0.0.0/0",
  ]
}

resource "aws_security_group_rule" "public_access_web" {
  type              = "ingress"
  to_port           = 0
  security_group_id = aws_security_group.web.id
  protocol          = "-1"
  from_port         = 0

  cidr_blocks = [
    "0.0.0.0/0",
  ]
}

resource "aws_security_group_rule" "icmp" {
  type              = "ingress"
  to_port           = 0
  security_group_id = aws_security_group.administration.id
  protocol          = "icmp"
  from_port         = 8

  cidr_blocks = [
    "0.0.0.0/0",
  ]
}

resource "aws_security_group_rule" "public_access_db" {
  type              = "egress"
  to_port           = 0
  security_group_id = aws_security_group.web.id
  protocol          = "-1"
  from_port         = 0

  cidr_blocks = [
    "0.0.0.0/0",
  ]
}

resource "aws_security_group_rule" "https" {
  type              = "ingress"
  to_port           = 443
  security_group_id = aws_security_group.web.id
  protocol          = "tcp"
  from_port         = 443

  cidr_blocks = [
    "0.0.0.0/0",
  ]
}

resource "aws_security_group_rule" "ssh" {
  type              = "ingress"
  to_port           = 22
  security_group_id = aws_security_group.administration.id
  protocol          = "tcp"
  from_port         = 22

  cidr_blocks = [
    "0.0.0.0/0",
  ]
}

resource "aws_security_group_rule" "http" {
  type              = "ingress"
  to_port           = 80
  security_group_id = aws_security_group.web.id
  protocol          = "tcp"
  from_port         = 80

  cidr_blocks = [
    "0.0.0.0/0",
  ]
}

resource "aws_security_group_rule" "public_access" {
  type              = "egress"
  to_port           = 0
  security_group_id = aws_security_group.administration.id
  protocol          = "-1"
  from_port         = 0

  cidr_blocks = [
    "0.0.0.0/0",
  ]
}

resource "aws_security_group" "db" {
  vpc_id      = aws_vpc.terraform.id
  name        = "db"
  description = "Allow db ingress trafic"

  tags = {
    Name = "db"
  }
}

resource "aws_security_group" "web" {
  vpc_id      = aws_vpc.terraform.id
  name        = "web"
  description = "Allow web ingress trafic"
}

resource "aws_instance" "http" {
  subnet_id     = aws_subnet.db.id
  key_name      = aws_key_pair.user_key.key_name
  instance_type = "t2.micro"
  for_each      = var.http_instance_names
  ami           = var.ami

  tags = {
    Name = each.key
  }

  vpc_security_group_ids = [
    aws_security_group.administration.id,
    aws_security_group.db.id,
  ]
}

resource "aws_instance" "db" {
  subnet_id     = aws_subnet.db.id
  key_name      = aws_key_pair.user_key.key_name
  instance_type = "t2.micro"
  for_each      = var.http_instance_names
  ami           = var.ami

  tags = {
    Name = each.key
  }

  vpc_security_group_ids = [
    aws_security_group.administration.id,
    aws_security_group.db.id,
  ]
}

resource "aws_eip" "public_http" {
  vpc      = true
  instance = aws_instance.http[each.key].id
  for_each = var.http_instance_names

  depends_on = [
    aws_internet_gateway.gw,
  ]

  tags = {
    Name = "public-http-${each.key}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.terraform.id

  route {
    gateway_id = aws_internet_gateway.gw.id
    cidr_block = "0.0.0.0/0"
  }

  tags = {
    Name = "public"
  }
}

resource "aws_route_table_association" "db" {
  subnet_id      = aws_subnet.db.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "http" {
  subnet_id      = aws_subnet.db.id
  route_table_id = aws_route_table.public.id
}

