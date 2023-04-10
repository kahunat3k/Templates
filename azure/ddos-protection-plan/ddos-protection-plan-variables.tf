# Brainboard auto-generated file.

variable "location" {
  type    = string
  default = "East US"
}

variable "snet_gateway_prefix" {
  description = "Gateway subnet prefix"
  type        = string
  default     = "10.221.0.0/26"
}

variable "tags" {
  description = "Default tags to apply to all resources."
  type        = map(any)
  default = {
    archuuid = "3219de31-cfaa-46f2-adda-e55d8a768743"
    env      = "Development"
  }
}

variable "vnet_main_addrspace" {
  description = "Virtual Network Address Space"
  type        = string
  default     = "10.221.0.0/21"
}

