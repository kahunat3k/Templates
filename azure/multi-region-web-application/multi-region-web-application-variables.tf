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

variable "region2" {
  type    = string
  default = "Central US"
}

variable "tags" {
  description = "Default tags to apply to all resources."
  type        = map(any)
  default = {
    archuuid = "cc1ad870-cfb7-4ffe-b7f0-9333ebe3f105"
    env      = "Development"
  }
}

