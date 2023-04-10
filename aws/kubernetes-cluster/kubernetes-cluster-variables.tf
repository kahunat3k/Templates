# Brainboard auto-generated file.

variable "cluster-name" {
  type    = string
  default = "brainboard-eks-demo"
}

variable "scaling" {
  description = "The scaling capacity of the cluster."
  type        = map(any)
  default = {
    desired = 1
    max     = 1
    min     = 1
  }
}

variable "sg_name" {
  description = "Default security group for the cluster."
  type        = string
  default     = "kube_sg"
}

variable "subnets" {
  description = "Subnets where cluster resources are deployed."
  type        = list(string)
  default     = ["10.0.0.0/24", "10.0.1.0/24"]
}

variable "tags" {
  description = "Default tags to apply to all resources."
  type        = map(any)
  default = {
    archuuid = "01bc0ca0-5297-4591-a9c7-a38add834ff5"
    env      = "Development"
  }
}

variable "vpc_cidr" {
  description = "CIDR block used by the main VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "workstation-external-cidr" {
  type    = string
  default = "0.0.0.0/0"
}

