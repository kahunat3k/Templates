# Brainboard auto-generated file.

variable "location" {
  type    = string
  default = "East US"
}

variable "prefix" {
  type    = string
  default = "demo"
}

variable "snet_default_hub_prefix" {
  description = "Default Hub Subnet Prefix"
  type        = string
  default     = "10.221.1.0/24"
}

variable "snet_default_spoke_prefix" {
  description = "Default Spoke Subnet Prefix"
  type        = string
  default     = "10.221.8.0/24"
}

variable "snet_dns_inbound_prefix" {
  description = "DNS Inbound Subnet Prefix"
  type        = string
  default     = "10.221.2.0/28"
}

variable "snet_dns_outbound_prefix" {
  description = "DNS Outbound Subnet Prefix"
  type        = string
  default     = "10.221.2.16/28"
}

variable "snet_firewall_prefix" {
  description = "Firewall Subnet Prefix"
  type        = string
  default     = "10.221.3.0/26"
}

variable "tags" {
  description = "Default tags to apply to all resources."
  type        = map(any)
  default = {
    archuuid = "0956676f-7f56-4dd3-982c-f733b2269892"
    env      = "Development"
  }
}

variable "vnet_hub_addrspace" {
  description = "Address Space for Hub Virtual Network"
  type        = string
  default     = "10.221.0.0/21"
}

variable "vnet_spoke_addrspace" {
  description = "Address Space for Spoke Virtual Network"
  type        = string
  default     = "10.221.8.0/24"
}

