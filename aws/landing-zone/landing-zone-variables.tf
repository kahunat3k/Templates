# Brainboard auto-generated file.

variable "private_subnets" {
  type = map
  default = {
    a = "10.0.1.0/24"
    b = "10.0.2.0/24"
    c = "10.0.3.0/24"
  }
}

variable "subnets" {
  description = "Default values for public subnets."
  type        = map
  default = {
    a = "10.0.1.0/24"
    b = "10.0.2.0/24"
    c = "10.0.3.0/24"
  }
}

variable "tags" {
  description = "Default tags to apply to all resources."
  type        = map
  default = {
    archuuid = "c3d39e04-f739-4649-807b-93dbcc7fafe3"
    env      = "Development"
  }
}

variable "vpc_cidr" {
  description = "The network addressing for the default VPC."
  type        = string
  default     = "10.0.0.0/16"
}

