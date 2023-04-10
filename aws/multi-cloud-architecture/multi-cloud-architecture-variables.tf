# Brainboard auto-generated file.

variable "firewallRule" {
  description = "firewallRule"
  type        = string
  default     = "firewallRule"
}

variable "tags" {
  description = "Default tags to apply to all resources."
  type        = map(any)
  default = {
    archuuid = "c7c372dc-d40e-497f-a9af-710b81623c81"
    env      = "Development"
  }
}

