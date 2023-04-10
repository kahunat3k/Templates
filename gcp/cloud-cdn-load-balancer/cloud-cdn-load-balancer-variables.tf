# Brainboard auto-generated file.

variable "fw_rule_port_range" {
  type    = number
  default = 80
}

variable "location" {
  type    = string
  default = "us-central1"
}

variable "project_id" {
  type    = string
  default = "project-id"
}

variable "tags" {
  description = "Default tags to apply to all resources."
  type        = map(any)
  default = {
    archuuid = "f91a73b3-1fce-49e6-a0ef-fb96a26dd952"
    env      = "Development"
  }
}

