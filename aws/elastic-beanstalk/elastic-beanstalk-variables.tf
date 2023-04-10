# Brainboard auto-generated file.

variable "asg_max_size" {
  type    = number
  default = 2
}

variable "asg_min_size" {
  type    = number
  default = 1
}

variable "beanstalk_env_name" {
  type    = string
  default = "brainboard"
}

variable "beastalk_app_name" {
  type    = string
  default = "brainboard"
}

variable "subnets" {
  default = {
    a = "10.0.1.0/24"
    b = "10.0.2.0/24"
  }
}

variable "tags" {
  description = "Default tags to apply to all resources."
  type        = map(any)
  default = {
    archuuid = "4abed2bb-ea43-468b-9f6a-dcfc68a46ebb"
    env      = "Development"
  }
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "vpc_name" {
  type    = string
  default = "brainboard"
}

