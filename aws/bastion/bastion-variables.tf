# Brainboard auto-generated file.

variable "debian_ami" {
  description = "Default Debian ami for region Frankfurt"
  type        = string
  default     = "ami-0adb6517915458bdb"
}

variable "ip" {
  description = "Authorized IP"
  type        = string
  default     = "0.0.0.0"
}

variable "public_key" {
  description = "Public key"
  type        = string
  default     = "your_public_key"
}

variable "tags" {
  description = "Default tags to apply to all resources."
  type        = map(any)
  default = {
    archuuid = "e8be87e2-bdaf-441e-b592-ee1c5d4478c6"
    env      = "Development"
  }
}

