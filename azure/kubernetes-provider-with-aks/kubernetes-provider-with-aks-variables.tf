# Brainboard auto-generated file.

variable "db_admin" {
  description = "MariaDB Database Admin Username"
  type        = string
  default     = "mariadbadmin"
}

variable "db_pass" {
  description = "MariaDB Database Admin Password"
  type        = string
  default     = "Br@inb0ard"
  sensitive   = true
}

variable "location" {
  type    = string
  default = "East US"
}

variable "snet_database_prefix" {
  description = "Database Subnet Prefix"
  type        = string
  default     = "10.221.10.0/24"
}

variable "snet_gateway_prefix" {
  description = "Gateway subnet prefix"
  type        = string
  default     = "10.221.9.0/24"
}

variable "snet_kube_prefix" {
  description = "Kubernetes Subnet Prefix"
  type        = string
  default     = "10.221.8.0/24"
}

variable "tags" {
  description = "Default tags to apply to all resources."
  type        = map(any)
  default = {
    archuuid = "212e5048-538a-4d92-9d7f-8e9cf50116b7"
    env      = "Development"
  }
}

variable "vnet_main_addrspace" {
  description = "Virtual Network Address Space"
  type        = string
  default     = "10.221.0.0/16"
}

