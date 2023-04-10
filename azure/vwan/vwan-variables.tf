# Brainboard auto-generated file.

variable "region-1-vnet-1-cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "region-2-vnet-1-cidr" {
  type    = string
  default = "10.10.0.0/16"
}

variable "tags" {
  description = "Default tags to apply to all resources."
  type        = map(any)
  default = {
    archuuid = "1fa4624f-33be-43df-a134-d74b959e6667"
    env      = "Development"
  }
}

variable "vwan-region1-hub1-prefix1" {
  type    = string
  default = "10.0.0.0/16"
}

variable "vwan-region2-hub1-prefix1" {
  type    = string
  default = "10.10.0.0/16"
}

