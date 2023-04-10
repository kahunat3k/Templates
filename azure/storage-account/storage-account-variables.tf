# Brainboard auto-generated file.

variable "location" {
  description = "The location where to put the storage."
  type        = string
  default     = "East US"
}

variable "rg_name" {
  description = "The name of the resource group containing the storage components."
  type        = string
  default     = "rg"
}

variable "tags" {
  description = "Default tags to apply to all resources."
  type        = map(any)
  default = {
    archuuid = "f79d7be8-e6a1-4de3-905e-be4245a9dd30"
    env      = "Development"
  }
}

