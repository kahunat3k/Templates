# Brainboard auto-generated file.

variable "app-service-name" {
  description = "The name of the app service resource"
  type        = string
  default     = "brainboard-app-service"
}

variable "app-service-plan-name" {
  description = "The name of the service plan"
  type        = string
  default     = "app-service-plan"
}

variable "app-service-sku-size" {
  description = "The size of the SKU service plan"
  type        = string
  default     = "S1"
}

variable "app-service-tier" {
  description = "The tier of the SKU service plan"
  type        = string
  default     = "Standard"
}

variable "rg_name" {
  description = "The name of the default resource group that contains all the resources for the web application"
  type        = string
  default     = "webRG"
}

variable "sql-db-name" {
  description = "The name of the SQL database"
  type        = string
  default     = "sql-db"
}

variable "sql-server-admin-user" {
  description = "The admin user for the SQL server"
  type        = string
  default     = "user1"
}

variable "sql-server-name" {
  description = "The name of the SQL server"
  type        = string
  default     = "brainboard-sql-server"
}

variable "tags" {
  description = "A map of tags to add to all resource"
  type        = map(string)
  default = {
    archuuid = "aea6bb02-8ce9-4c0d-a76f-f970febdd389"
    env      = "Development"
  }
}

