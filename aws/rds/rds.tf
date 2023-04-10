# Brainboard auto-generated file.

resource "aws_vpc" "default" {
  cidr_block = var.vpc_cird

  tags = {
    Env = "Dev"
  }
}

resource "aws_db_subnet_group" "default" {
  name        = "default_subnet_group"
  description = "The default subnet group for all DBs in this architecture"

  subnet_ids = [
    aws_subnet.subnet_w_2a.id,
    aws_subnet.subnet_w_2b.id,
    aws_subnet.subnet_w_2a.id, aws_subnet.subnet_w_2b.id,
  ]

  tags = {
    env = "Dev"
  }
}

resource "aws_subnet" "subnet_w_2a" {
  vpc_id            = aws_vpc.default.id
  cidr_block        = var.subnets.w_2a
  availability_zone = "us-west-2a"

  tags = {
    env = "Dev"
  }
}

resource "aws_subnet" "subnet_w_2b" {
  vpc_id            = aws_vpc.default.id
  cidr_block        = var.subnets.w_2b
  availability_zone = "us-west-2b"

  tags = {
    env = "Dev"
  }
}

resource "aws_db_instance" "db1" {
  username             = "brainboard"
  skip_final_snapshot  = true
  publicly_accessible  = true
  password             = var.db_password
  parameter_group_name = aws_db_parameter_group.log_db_parameter.name
  instance_class       = var.instance_class
  engine_version       = "13.1"
  engine               = "postgres"
  db_subnet_group_name = aws_db_subnet_group.default.name
  allocated_storage    = 50

  tags = {
    env = "Dev"
  }

  vpc_security_group_ids = [
    aws_security_group.default.id,
    aws_security_group.default.id,
  ]
}

resource "aws_security_group" "default" {
  vpc_id      = aws_vpc.default.id
  name        = "default_db_sg"
  description = "Default sg for the database"

  ingress {
    to_port     = var.db_port
    protocol    = "tcp"
    from_port   = var.db_port
    description = "Allow connections to the database"
  }

  tags = {
    env = "Dev"
  }
}

resource "aws_db_parameter_group" "log_db_parameter" {
  name   = "logs"
  family = "postgres13"

  parameter {
    value = "1"
    name  = "log_connections"
  }

  tags = {
    env = "Dev"
  }
}

resource "aws_db_instance" "db_replica" {
  skip_final_snapshot  = true
  replicate_source_db  = aws_db_instance.db1.identifier
  publicly_accessible  = true
  parameter_group_name = aws_db_parameter_group.log_db_parameter.name
  instance_class       = var.instance_class
  identifier           = "db-replica"
  apply_immediately    = true

  tags = {
    replica = "true"
    env     = "Dev"
  }

  vpc_security_group_ids = [
    aws_security_group.default.id,
  ]
}

