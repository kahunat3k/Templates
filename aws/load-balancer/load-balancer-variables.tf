# Brainboard auto-generated file.

variable "subnet2_cidr" {
  type    = string
  default = "10.0.2.0/24"
}

variable "subnet_cidr" {
  description = "The default subnet CIDR."
  type        = string
  default     = "10.0.1.0/24"
}

variable "tags" {
  description = "Default tags to apply to all resources."
  type        = map(any)
  default = {
    archuuid = "222804d0-0e6f-45e8-9a83-b0c1928d56bc"
    env      = "Development"
  }
}

variable "vpc_cidr" {
  description = "The default VPC CIDR block."
  type        = string
  default     = "10.0.0.0/16"
}

