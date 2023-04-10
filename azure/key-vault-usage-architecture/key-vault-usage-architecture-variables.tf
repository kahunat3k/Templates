# Brainboard auto-generated file.

variable "keyvaultname" {
  type    = string
  default = "kv-yiddoxgn"
}

variable "location" {
  type    = string
  default = "East US"
}

variable "tags" {
  description = "Default tags to apply to all resources."
  type        = map(any)
  default = {
    archuuid = "2438d2dd-6448-4be4-b427-37aee7cf28fe"
    env      = "Development"
  }
}

