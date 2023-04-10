# Brainboard auto-generated file.

variable "max_capacity" {
  type    = number
  default = 5
}

variable "min_capacity" {
  type    = number
  default = 1
}

variable "subnets" {
  type = list
  default = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]
}

variable "tags" {
  description = "Default tags to apply to all resources."
  type        = map(any)
  default = {
    archuuid = "ec8a1750-2c51-4c61-8973-b524157151b7"
    env      = "Development"
  }
}

variable "vpc_cidr" {
  description = "Value of VPC cidr"
  type        = string
  default     = "10.0.0.0/16"
}

