# Brainboard auto-generated file.

variable "enable_ssl 1 : 0" {
}

variable "enable_ssl ?1 : 0" {
}

variable "firewallRule" {
  description = "firewallRule"
  type        = string
  default     = "firewallRule"
}

variable "tags" {
  description = "Default tags to apply to all resources."
  type        = map(any)
  default = {
    archuuid = "64192fc3-238e-401b-94c4-b94e45a8fa19"
    env      = "Development"
  }
}

variable "url_map" {
}

