# Brainboard auto-generated file.

variable "region" {
  description = "The default region"
  type        = string
  default     = "eu-east-1"
}

variable "tags" {
  description = "Default tags to apply to all resources."
  type        = map(any)
  default = {
    archuuid = "a2af619f-d30e-45db-a5aa-199285f93c0f"
    env      = "Development"
  }
}

