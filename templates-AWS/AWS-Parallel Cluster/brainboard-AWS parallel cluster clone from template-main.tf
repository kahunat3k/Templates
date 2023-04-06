# Brainboard auto-generated file.

resource "aws_vpc" "vpc_2" {
  cidr_block = var.vpc_cidr

  tags = {
    env      = "Development"
    archUUID = "4cd9e97a-10be-4aa0-9e06-bd1dbee53a79"
  }
}

resource "aws_security_group" "security_group_4" {
  vpc_id = aws_vpc.vpc_2.id
  name   = "pCluster"

  egress {
    to_port   = -1
    protocol  = "tcp"
    from_port = -1
    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }

  ingress {
    to_port     = 443
    protocol    = "tcp"
    from_port   = 443
    description = "HTTPs only"
    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }

  tags = {
    env      = "Development"
    archUUID = "4cd9e97a-10be-4aa0-9e06-bd1dbee53a79"
  }
}

resource "aws_autoscaling_group" "asg_5" {
  min_size             = var.min_capacity
  max_size             = var.max_capacity
  launch_configuration = aws_launch_configuration.pCluster_lc.name

  availability_zones = [
    "ap-southeast-2a",
    "ap-southeast-2b",
  ]
}

resource "aws_instance" "c5_6_c_1_c" {
  availability_zone = "ap-southeast-2a"

  security_groups = [
    aws_security_group.security_group_4.id,
    aws_security_group.security_group_4.id,
    aws_security_group.security_group_4.id,
    aws_security_group.security_group_4.id,
  ]

  tags = {
    env      = "Development"
    archUUID = "4cd9e97a-10be-4aa0-9e06-bd1dbee53a79"
  }
}

resource "aws_instance" "c5_6_c_2_c_c_c" {
  availability_zone = "ap-southeast-2a"

  security_groups = [
    aws_security_group.security_group_4.id,
    aws_security_group.security_group_4.id,
    aws_security_group.security_group_4.id,
    aws_security_group.security_group_4.id,
  ]

  tags = {
    env      = "Development"
    archUUID = "4cd9e97a-10be-4aa0-9e06-bd1dbee53a79"
  }
}

resource "aws_instance" "c5_6_c" {
  availability_zone = "ap-southeast-2b"

  security_groups = [
    aws_security_group.security_group_4.id,
    aws_security_group.security_group_4.id,
    aws_security_group.security_group_4.id,
    aws_security_group.security_group_4.id,
  ]

  tags = {
    env      = "Development"
    archUUID = "4cd9e97a-10be-4aa0-9e06-bd1dbee53a79"
  }
}

resource "aws_dynamodb_table" "dynamodb_table_8" {
  write_capacity = 30
  read_capacity  = 30
  name           = "pCluster"
  billing_mode   = "PROVISIONED"

  tags = {
    env      = "Development"
    archUUID = "4cd9e97a-10be-4aa0-9e06-bd1dbee53a79"
  }
}

resource "aws_ssm_document" "ssm_document_9" {
  name          = "pCluster_session_manger"
  document_type = "Command"
  content       = <<DOC
  {
    "schemaVersion": "1.2",
    "description": "Check ip configuration of a Linux instance.",
    "parameters": {

    },
    "runtimeConfig": {
      "aws:runShellScript": {
        "properties": [
          {
            "id": "0.aws:runShellScript",
            "runCommand": ["ifconfig"]
          }
        ]
      }
    }
  }
DOC

  tags = {
    env      = "Development"
    archUUID = "4cd9e97a-10be-4aa0-9e06-bd1dbee53a79"
  }
}

resource "aws_ssm_activation" "ssm_activation_11" {
  iam_role = aws_iam_role.default.id

  tags = {
    env      = "Development"
    archUUID = "4cd9e97a-10be-4aa0-9e06-bd1dbee53a79"
  }
}

resource "aws_launch_configuration" "pCluster_lc" {
  instance_type = "c5n.large"
  image_id      = var.Official_Debian_AMi

  security_groups = [
    aws_security_group.security_group_4.id,
    aws_security_group.security_group_4.id,
  ]
}

resource "aws_iam_role" "default" {
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    env      = "Development"
    archUUID = "4cd9e97a-10be-4aa0-9e06-bd1dbee53a79"
  }
}

