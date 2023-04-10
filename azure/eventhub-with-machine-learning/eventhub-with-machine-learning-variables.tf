# Brainboard auto-generated file.

variable "location" {
  type    = string
  default = "East US"
}

variable "synapse_admin_pass" {
  type      = string
  default   = "Br@inb0ard"
  sensitive = true
}

variable "tags" {
  description = "Default tags to apply to all resources."
  type        = map(any)
  default = {
    archuuid = "1595c604-8c99-42ad-92a6-f00bee2bd5ab"
    env      = "Development"
  }
}

