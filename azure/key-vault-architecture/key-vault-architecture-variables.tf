# Brainboard auto-generated file.

variable "admin_password" {
  type    = string
  default = "P@ssword1234!"
}

variable "location" {
  type    = string
  default = "East US"
}

variable "tags" {
  description = "Default tags to apply to all resources."
  type        = map(any)
  default = {
    archuuid = "309aafb8-d2b3-48cf-97f9-ed38d68eec75"
    env      = "Development"
  }
}

