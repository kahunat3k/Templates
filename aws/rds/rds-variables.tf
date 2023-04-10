# Brainboard auto-generated file.

variable "db_password" {
  description = "The password of the database"
  type        = string
  default     = "changeme123"
  sensitive   = true
}

variable "db_port" {
  type      = string
  default   = "5432"
  sensitive = true
}

variable "instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "subnets" {
  type = map
  default = {
    w_2a = "10.0.1.0/24"
    w_2b = "10.0.2.0/24"
  }
}

variable "tags" {
  description = "Default tags to apply to all resources."
  type        = map(any)
  default = {
    archuuid = "bfa94b37-aea6-4de2-96bc-77fe57f2941a"
    env      = "Development"
  }
}

variable "vpc_cird" {
  description = "The default VPC of the database"
  type        = string
  default     = "10.0.0.0/16"
}

