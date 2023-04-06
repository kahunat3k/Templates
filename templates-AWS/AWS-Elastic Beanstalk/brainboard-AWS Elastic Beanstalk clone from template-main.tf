# Brainboard auto-generated file.

resource "aws_vpc" "default" {
  tags       = merge(var.tags, {})
  cidr_block = var.vpc_cidr
}

resource "aws_subnet" "subnet_2a" {
  vpc_id                  = aws_vpc.default.id
  tags                    = merge(var.tags, {})
  map_public_ip_on_launch = true
  cidr_block              = var.subnets.a
  availability_zone       = "ap-southeast-2a"
}

resource "aws_subnet" "subnet_2b" {
  vpc_id                  = aws_vpc.default.id
  tags                    = merge(var.tags, {})
  map_public_ip_on_launch = true
  cidr_block              = var.subnets.b
  availability_zone       = "ap-southeast-2b"
}

resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id
  tags   = merge(var.tags, {})
}

resource "aws_elastic_beanstalk_environment" "default" {
  wait_for_ready_timeout = "1h"
  tier                   = "WebServer"
  tags                   = merge(var.tags, {})
  solution_stack_name    = "64bit Amazon Linux 2 v3.4.3 running Python 3.8"
  name                   = var.beanstalk_env_name
  application            = aws_elastic_beanstalk_application.default.id

  setting {
    value     = aws_vpc.default.id
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
  }
  setting {
    value     = join(",", [aws_subnet.subnet_2a.id, aws_subnet.subnet_2b.id])
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
  }
  setting {
    value     = "aws-elasticbeanstalk-ec2-role"
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
  }
  setting {
    value     = "True"
    namespace = "aws:ec2:vpc"
    name      = "AssociatePublicIpAddress"
  }
  setting {
    value     = "200"
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name      = "MatcherHTTPCode"
  }
  setting {
    value     = "application"
    namespace = "aws:elasticbeanstalk:environment"
    name      = "LoadBalancerType"
  }
  setting {
    value     = "t2.medium"
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
  }
  setting {
    value     = "internet facing"
    namespace = "aws:ec2:vpc"
    name      = "ELBScheme"
  }
  setting {
    value     = var.asg_min_size
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
  }
  setting {
    value     = var.asg_max_size
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
  }
  setting {
    value     = "enhanced"
    namespace = "aws:elasticbeanstalk:healthreporting:system"
    name      = "SystemType"
  }
  setting {
    value     = "True"
    namespace = "aws:elb:loadbalancer"
    name      = "CrossZone"
  }
  setting {
    value     = join(",", [aws_subnet.subnet_2a.id, aws_subnet.subnet_2b.id])
    namespace = "aws:ec2:vpc"
    name      = "ELBSubnets"
  }
}

resource "aws_elastic_beanstalk_application" "default" {
  tags = merge(var.tags, {})
  name = var.beastalk_app_name
}

resource "aws_route_table" "default" {
  vpc_id = aws_vpc.default.id
  tags   = merge(var.tags, {})

  route {
    gateway_id = aws_internet_gateway.default.id
    cidr_block = "0.0.0.0/0"
  }
}

resource "aws_route_table_association" "route_table_association_2b" {
  subnet_id      = aws_subnet.subnet_2b.id
  route_table_id = aws_route_table.default.id
}

resource "aws_route_table_association" "route_table_association_2a" {
  subnet_id      = aws_subnet.subnet_2a.id
  route_table_id = aws_route_table.default.id
}

