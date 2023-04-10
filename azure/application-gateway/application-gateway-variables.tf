# Brainboard auto-generated file.

variable "admin_password" {
  type      = string
  default   = "Br@inb0ard!"
  sensitive = true
}

variable "location" {
  type    = string
  default = "East US"
}

variable "snet_backend" {
  type    = string
  default = "10.3.3.0/24"
}

variable "snet_db" {
  type    = string
  default = "10.3.4.0/24"
}

variable "snet_frontend" {
  type    = string
  default = "10.3.2.0/24"
}

variable "snet_monitoring" {
  type    = string
  default = "10.3.5.0/24"
}

variable "tags" {
  description = "Default tags to apply to all resources."
  type        = map(any)
  default = {
    archuuid = "9e53bf09-9c56-4140-9d68-70c68d0f6995"
    env      = "Development"
  }
}

variable "vnet_address" {
  type    = string
  default = "10.3.0.0/16"
}

