# Brainboard auto-generated file.

resource "aws_vpc" "aws_vpc_3" {
  cidr_block = var.cidr

  tags = {
    env      = "Dev"
    archUUID = "d98ef793-a3ed-45bc-b746-c2494b135cf3"
  }
}

resource "aws_subnet" "aws_subnet_4" {
  vpc_id            = aws_vpc.aws_vpc_3.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-2a"

  tags = {
    env      = "Dev"
    archUUID = "d98ef793-a3ed-45bc-b746-c2494b135cf3"
  }
}

resource "aws_security_group" "default" {
  vpc_id = aws_vpc.aws_vpc_3.id

  tags = {
    env      = "Dev"
    archUUID = "d98ef793-a3ed-45bc-b746-c2494b135cf3"
  }
}

resource "aws_lb_listener" "aws_lb_listener_8" {
  protocol          = "http"
  port              = 8080
  load_balancer_arn = aws_lb.default.arn

  tags = {
    env      = "Dev"
    archUUID = "d98ef793-a3ed-45bc-b746-c2494b135cf3"
  }

  default_action {
    type = "forward"
    forward {
      target_group {
        arn    = aws_lb_target_group.blue.arn
        weight = lookup(var.traffic_dist_map[var.traffic_distribution], "blue", 100)
      }
      target_group {
        arn    = aws_lb_target_group.green.arn
        weight = lookup(var.traffic_dist_map[var.traffic_distribution], "green", 0)
      }
      stickiness {
        enabled  = false
        duration = 1
      }
    }
  }
}

resource "aws_lb_target_group" "blue" {
  vpc_id                             = aws_vpc.aws_vpc_3.id
  protocol                           = "HTTP"
  port                               = 8080
  name                               = "lb-group"
  lambda_multi_value_headers_enabled = true

  health_check {
    unhealthy_threshold = 10
    timeout             = 5
    port                = var.lb_port
    path                = var.lb_path
    interval            = 10
    healthy_threshold   = 3
  }

  stickiness {
    type            = "lb_cookie"
    enabled         = true
    cookie_duration = 1800
  }

  tags = {
    env      = "Dev"
    archUUID = "d98ef793-a3ed-45bc-b746-c2494b135cf3"
  }
}

resource "aws_lb_target_group" "aws_lb_target_group-62d0b171" {
  vpc_id   = aws_vpc.aws_vpc_3.id
  protocol = "HTTP"
  port     = 8080
  name     = "lb-group"

  health_check {
    unhealthy_threshold = 10
    timeout             = 5
    port                = var.lb_port
    path                = var.lb_path
    interval            = 10
    healthy_threshold   = 3
  }

  stickiness {
    type            = "lb_cookie"
    enabled         = true
    cookie_duration = 1800
  }

  tags = {
    env      = "Dev"
    archUUID = "d98ef793-a3ed-45bc-b746-c2494b135cf3"
  }
}

resource "aws_lb_target_group_attachment" "green" {
  target_id         = aws_instance.green.id
  target_group_arn  = aws_lb_target_group.blue.arn
  port              = 80
  availability_zone = "us-east-2a"
}

resource "aws_lb_target_group_attachment" "blue" {
  target_id         = aws_instance.blue.id
  target_group_arn  = aws_lb_target_group.blue.arn
  port              = 80
  availability_zone = "us-east-2a"
}

resource "aws_instance" "blue" {
  subnet_id         = aws_subnet.aws_subnet_4.id
  instance_type     = "t3a.micro"
  availability_zone = "us-east-2a"
  ami               = "ami-005e54dee72cc1d00"

  security_groups = [
    aws_security_group.default.id,
  ]

  tags = {
    env      = "Dev"
    archUUID = "d98ef793-a3ed-45bc-b746-c2494b135cf3"
  }
}

resource "aws_instance" "green" {
  subnet_id         = aws_subnet.aws_subnet_4.id
  instance_type     = "t3a.micro"
  availability_zone = "us-east-2a"
  ami               = "ami-005e54dee72cc1d01"

  security_groups = [
    aws_security_group.default.id,
  ]

  tags = {
    env      = "Dev"
    archUUID = "d98ef793-a3ed-45bc-b746-c2494b135cf3"
  }
}

resource "aws_lb" "default" {
  name               = "main-app-lb"
  load_balancer_type = "application"

  security_groups = [
    aws_security_group.default.id,
  ]

  subnets = [
    aws_subnet.aws_subnet_4.id,
  ]

  tags = {
    env      = "Dev"
    archUUID = "d98ef793-a3ed-45bc-b746-c2494b135cf3"
  }
}

