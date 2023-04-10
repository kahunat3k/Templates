# Brainboard auto-generated file.

variable "name_prefix" {
  description = "The prefix on all names of this architectures. It should be lowercase."
  type        = string
  default     = "brainboard"
}

variable "server_login" {
  type    = string
  default = "brainboardAdmin"
}

variable "server_password" {
  type      = string
  default   = "Br@1nb0rd!"
  sensitive = true
}

variable "subnet_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "tags" {
  description = "Default tags to apply to all resources."
  type        = map(any)
  default = {
    archuuid = "780da763-0cde-47fc-86dc-419c7a0231e2"
    env      = "Development"
  }
}

variable "vnet_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

