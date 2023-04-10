# Brainboard auto-generated file.

variable "region" {
  description = "Region of the event handler"
  type        = string
  default     = "us-west-2"
}

variable "tags" {
  description = "Default tags to apply to all resources."
  type        = map(any)
  default = {
    archuuid = "23e214d8-a9d9-4bd0-95bf-ce6900d6b97f"
    env      = "Development"
  }
}

