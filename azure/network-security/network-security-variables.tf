# Brainboard auto-generated file.

variable "location" {
  type    = string
  default = "West US"
}

variable "rg_name" {
  type    = string
  default = "network-rg"
}

variable "tags" {
  description = "Default tags to apply to all resources."
  type        = map(any)
  default = {
    archuuid = "469310d8-a8c1-4794-804a-8355bcb32ea7"
    env      = "Development"
  }
}

