# Brainboard auto-generated file.

variable "environment == " testing " ? 1 : 0" {
}

variable "location" {
  type    = string
  default = "East US"
}

variable "tags" {
  description = "Default tags to apply to all resources."
  type        = map(any)
  default = {
    archuuid = "5acc5491-56d1-49d9-ba9e-9b3eb9535904"
    env      = "Development"
  }
}

