# Brainboard auto-generated file.

variable "address_space" {
  description = "The default address space for the virtual network."
  type        = string
  default     = "10.0.0.0/16"
}

variable "location" {
  description = "Location of the Sentinel installation"
  type        = string
  default     = "East US"
}

variable "tags" {
  description = "Default tags to apply to all resources"
  type        = map
  default = {
    archuuid = "cb240db5-a8de-48cc-a4ea-d1edb6d16777"
    env      = "Development"
  }
}

