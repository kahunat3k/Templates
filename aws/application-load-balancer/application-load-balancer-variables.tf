# Brainboard auto-generated file.

variable "ami" {
  type    = string
  default = "ami-123"
}

variable "cidr" {
  type      = string
  default   = "10.0.0.0/16"
  sensitive = true
}

variable "enable_green_env" {
  description = "Enable green environment"
  type        = bool
  default     = true
}

variable "lb_path" {
  type    = string
  default = "/"
}

variable "lb_port" {
  type    = string
  default = "8080"
}

variable "tags" {
  description = "Default tags to apply to all resources."
  type        = map(any)
  default = {
    archuuid = "fdb930ad-c542-4414-a37f-81d59cbbd263"
    env      = "Development"
  }
}

variable "traffic_dist_map" {
  default = {
    blue = {
      blue  = 100
      green = 0
    }
    blue-90 = {
      blue  = 90
      green = 10
    }
    split = {
      blue  = 50
      green = 50
    }
    green-90 = {
      blue  = 10
      green = 90
    }
    green = {
      blue  = 0
      green = 100
    }
  }
}

