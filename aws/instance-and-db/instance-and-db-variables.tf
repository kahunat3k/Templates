# Brainboard auto-generated file.

variable "ami" {
  description = "Defautl AMI in eu-west-1"
  type        = string
  default     = "ami-02c160578d2b40098"
}

variable "db_instance_names" {
  type    = set
  default = ["instance-db-1", "instance-db-2", "instance-db-3"]
}

variable "http_instance_names" {
  type    = set
  default = ["instance-http-1", "instance-http-2"]
}

variable "network_db" {
  type = map
  default = {
    subnet_name = "subnet_db"
    cidr        = "192.168.2.0/24"
  }
}

variable "network_http" {
  type = map
  default = {
    subnet_name = "subnet_http"
    cidr        = "192.168.1.0/24"
  }
}

variable "public_key" {
  type    = string
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD3F6tyPEFEzV0LX3X8BsXdMsQz1x2cEikKDEY0aIj41qgxMCP/iteneqXSIFZBp5vizPvaoIR3Um9xK7PGoW8giupGn+EPuxIA4cDM4vzOqOkiMPhz5XK0whEjkVzTo4+S0puvDZuwIsdiW9mxhJc7tgBNL0cYlWSYVkz4G/fslNfRPW5mYAM49f4fhtxPb5ok4Q2Lg9dPKVHO/Bgeu5woMc7RY0p1ej6D4CKFE6lymSDJpW0YHX/wqE9+cfEauh7xZcG0q9t2ta6F6fmX0agvpFyZo8aFbXeUBr7osSCJNgvavWbM/06niWrOvYX2xwWdhXmXSrbX8ZbabVohBK41 email@example.com"
}

variable "tags" {
  description = "Default tags to apply to all resources."
  type        = map(any)
  default = {
    archuuid = "dc93bddc-211f-482a-b49b-14c129553e20"
    env      = "Development"
  }
}

variable "vpc_cidr" {
  type    = string
  default = "192.168.0.0/16"
}

