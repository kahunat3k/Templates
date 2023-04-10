# Brainboard auto-generated file.

variable "subnet1" {
  type    = string
  default = "10.0.1.0/24"
}

variable "subnet2" {
  type    = string
  default = "10.0.2.0/24"
}

variable "tags" {
  description = "Default tags to apply to all resources."
  type        = map(any)
  default = {
    archuuid = "c31a4200-8bbe-4801-a727-e8269c7c4f4e"
    env      = "Development"
  }
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

