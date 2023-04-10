# Brainboard auto-generated file.

variable "base64-certificate" {
  type = string
}

variable "objectID" {
  description = "Object ID."
  type        = string
  default     = "00000000-0000-0000-0000-000000000000"
}

variable "password" {
  type = string
}

variable "prefix" {
  description = "The prefix used for all resources."
  type        = string
  default     = "brainboard"
}

variable "tags" {
  description = "Default tags to apply to all resources."
  type        = map(any)
  default = {
    archuuid = "16fe37cf-61fd-4d20-9c97-0950ea622bb4"
    env      = "Development"
  }
}

variable "tenantID" {
  description = "Tenant ID."
  type        = string
  default     = "00000000-0000-0000-0000-000000000000"
}

variable "web-objectID" {
  description = "Object ID for web service principal."
  type        = string
  default     = "00000000-0000-0000-0000-000000000000"
}

variable "web-tenantID" {
  description = "Tenant ID for web service principal."
  type        = string
  default     = "00000000-0000-0000-0000-000000000000"
}

