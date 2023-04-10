# Brainboard auto-generated file.

variable "admin_password" {
  type      = string
  default   = "Br@inb0ard"
  sensitive = true
}

variable "location" {
  type    = string
  default = "East US"
}

variable "tags" {
  description = "Default tags to apply to all resources."
  type        = map(any)
  default = {
    archuuid = "16df4cbd-fc07-4ced-a8e8-57ead30992e7"
    env      = "Development"
  }
}

