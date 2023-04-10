# Brainboard auto-generated file.

variable "amount_limitation" {
  type    = number
  default = 1000
}

variable "ec2_amount_limitation" {
  type    = number
  default = 500
}

variable "ec2_threshold" {
  type    = number
  default = 400
}

variable "email" {
  type    = string
  default = "contact@brainboard.co"
}

variable "s3_amount" {
  type    = number
  default = 100
}

variable "tags" {
  description = "Default tags to apply to all resources."
  type        = map(any)
  default = {
    archuuid = "deae990e-8e97-4daa-a0cc-f759e3b01266"
    env      = "Development"
  }
}

variable "threshold" {
  type    = number
  default = 800
}

