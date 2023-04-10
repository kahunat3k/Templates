# Brainboard auto-generated file.

variable "hostname" {
  type    = string
  default = "test.com"
}

variable "location" {
  type    = string
  default = "East US"
}

variable "region1" {
  type    = string
  default = "East US"
}

variable "tags" {
  description = "Default tags to apply to all resources."
  type        = map(any)
  default = {
    archuuid = "73066ba1-57a4-420b-87ea-1ff2fe402475"
    env      = "Development"
  }
}

