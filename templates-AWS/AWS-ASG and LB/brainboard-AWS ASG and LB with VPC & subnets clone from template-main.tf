# Brainboard auto-generated file.

resource "aws_vpc" "default" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "Brainboard demo"
  }
}

resource "aws_subnet" "subnet2" {
  vpc_id                  = aws_vpc.default.id
  map_public_ip_on_launch = true
  cidr_block              = var.subnet2
  availability_zone       = "us-east-1b"

  tags = {
    Name = "Brainboard demo subnet2"
  }
}

resource "aws_subnet" "subnet1" {
  vpc_id                  = aws_vpc.default.id
  map_public_ip_on_launch = true
  cidr_block              = var.subnet1
  availability_zone       = "us-east-1a"
}

resource "aws_route_table" "route" {
  vpc_id = aws_vpc.default.id

  route {
    gateway_id = aws_internet_gateway.default.id
    cidr_block = "0.0.0.0/0"
  }

  tags = {
    Name = "Brainboard demo"
  }
}

resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id

  tags = {
    Name = "Brainboard demo"
  }
}

resource "aws_route_table_association" "rt1" {
  subnet_id      = aws_subnet.subnet2.id
  route_table_id = aws_route_table.route.id
}

resource "aws_route_table_association" "rt2" {
  subnet_id      = aws_subnet.subnet2.id
  route_table_id = aws_route_table.route.id
}

resource "aws_security_group" "default" {
  vpc_id      = aws_vpc.default.id
  name        = "Default SG"
  description = "Default SG for the LB"

  tags = {
    Name = "Brainboard demo"
  }

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  } # HTTPS access from anywhere
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  } # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  } # Outbound Rules
  # Internet access to anywhere
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_elb" "clb_9" {
  cross_zone_load_balancing = true

  health_check {
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
    healthy_threshold   = 2
  }

  listener {
    lb_protocol       = "http"
    lb_port           = 80
    instance_protocol = "http"
    instance_port     = 80
  }

  security_groups = [
    aws_security_group.default.id,
  ]

  subnets = [
    aws_subnet.subnet1.id,
    aws_subnet.subnet2.id,
  ]

  tags = {
    Name = "Brainboard demo"
  }
}

resource "aws_launch_configuration" "default" {
  instance_type               = "t2.micro"
  image_id                    = "ami-087c17d1fe0178315"
  associate_public_ip_address = true

  lifecycle {
    create_before_destroy = true
  }

  security_groups = [
    aws_security_group.default.id,
  ]
}

resource "aws_security_group" "ec2-sg" {
  vpc_id = aws_vpc.default.id
  name   = "EC2 SG"

  tags = {
    Name = "Brainboard demo EC2 SG"
  }

  # Inbound Rules
  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  } # HTTPS access from anywhere
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  } # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  } # Outbound Rules
  # Internet access to anywhere
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_autoscaling_group" "web" {
  min_size             = 1
  max_size             = 2
  launch_configuration = aws_launch_configuration.default.name
  health_check_type    = "ELB"
  desired_capacity     = 1

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances",
  ]

  lifecycle {
    create_before_destroy = true
  }

  load_balancers = [
    aws_elb.clb_9.id,
  ]

  vpc_zone_identifier = [
    aws_subnet.subnet1.id,
    aws_subnet.subnet2.id,
  ]
}

resource "aws_autoscaling_policy" "web_policy_down" {
  scaling_adjustment     = -1
  name                   = "web_policy_down"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.web.name
  adjustment_type        = "ChangeInCapacity"
}

resource "aws_autoscaling_policy" "default" {
  scaling_adjustment     = 1
  name                   = "web_policy_up"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.web.name
  adjustment_type        = "ChangeInCapacity"
}

resource "aws_cloudwatch_metric_alarm" "web_cpu_alarm_up" {
  threshold           = 70
  statistic           = "Average"
  period              = 120
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"
  evaluation_periods  = 2
  comparison_operator = "GreaterThanOrEqualToThreshold"
  alarm_name          = "web_cpu_alarm_up"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web.name
  }
}

resource "aws_cloudwatch_metric_alarm" "web_cpu_alarm_down" {
  threshold           = 30
  statistic           = "Average"
  period              = 120
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"
  evaluation_periods  = 2
  comparison_operator = "LessThanOrEqualToThreshold"
  alarm_name          = "web_cpu_alarm_down"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web.name
  }
}

