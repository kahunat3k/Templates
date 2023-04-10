# Brainboard auto-generated file.

resource "aws_vpc" "default" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "subnet2" {
  vpc_id            = aws_vpc.default.id
  cidr_block        = var.subnet2_cidr
  availability_zone = "us-east-2b"
}

resource "aws_subnet" "default" {
  vpc_id            = aws_vpc.default.id
  cidr_block        = var.subnet_cidr
  availability_zone = "us-east-2a"
}

resource "aws_security_group" "sg" {
  vpc_id = aws_vpc.default.id
}

resource "aws_lb_listener" "lb_listner" {
  port              = 8080
  load_balancer_arn = aws_lb.alb.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.aws_lb_target_group_8.arn
  }
}

resource "aws_lb_target_group" "aws_lb_target_group_8" {
  vpc_id   = aws_vpc.default.id
  protocol = "HTTP"
  port     = 8080
  name     = "target-group"
}

resource "aws_instance" "t3a_9" {
  subnet_id     = aws_subnet.default.id
  instance_type = "t3a.micro"
  ami           = "ami-0c2a979b1dbc84003"

  security_groups = [
    aws_security_group.sg.id,
    aws_security_group.sg.id,
    aws_security_group.sg.id,
  ]
}

resource "aws_lb_target_group_attachment" "aws_lb_target_group_attachment_10" {
  target_id        = aws_instance.t3a_9.id
  target_group_arn = aws_lb_target_group.aws_lb_target_group_8.arn
}

resource "aws_lb" "alb" {

  security_groups = [
    aws_security_group.sg.id,
  ]

  subnets = [
    aws_subnet.default.id,
    aws_subnet.subnet2.id,
  ]
}

resource "aws_internet_gateway" "aws_internet_gateway_12" {
  vpc_id = aws_vpc.default.id
}

