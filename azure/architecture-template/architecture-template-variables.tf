# Brainboard auto-generated file.

variable "admin_password" {
  description = "Change this password."
  type        = string
  default     = "1Wk#Fj#^ZC>wDAnMj8]H)p8F)kr>a"
  sensitive   = true
}

variable "admin_user" {
  description = "Admin user of the virtual machine."
  type        = string
  default     = "administrator"
}

variable "computer_name" {
  description = "The name of the virtual machine."
  type        = string
  default     = "brainboard"
}

variable "lb_name" {
  description = "The name of the default load balancer."
  type        = string
  default     = "loadbalancer"
}

variable "nic_name" {
  description = "Network interface name attached the the VM."
  type        = string
  default     = "vm_nic"
}

variable "rg_name" {
  description = "The default resource group name."
  type        = string
  default     = "brainboard"
}

variable "subnet_cidr" {
  description = "The default address prefix for the subnet."
  type        = string
  default     = "10.0.1.0/24"
}

variable "subnet_name" {
  type    = string
  default = "snet"
}

variable "tags" {
  description = "Default tags to apply to all resources."
  type        = map(any)
  default = {
    archuuid = "623efd64-03c6-40c0-a754-b2b6e772d79b"
    env      = "Development"
  }
}

variable "vm_name" {
  type    = string
  default = "brainboard"
}

variable "vm_size" {
  type    = string
  default = "Standard_DS1_v2"
}

variable "vnet_cidr" {
  description = "The address prefix of the virtual network."
  type        = string
  default     = "10.0.0.0/16"
}

variable "vnet_name" {
  type    = string
  default = "vnet"
}

