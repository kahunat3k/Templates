# Brainboard auto-generated file.

variable "location" {
  description = "The Azure Region in which all resources in this example should be created."
  type        = string
  default     = "North Central US"
}

variable "open_api_spec_content_format" {
  description = "The format of the content from which the API Definition should be imported. Possible values are: openapi, openapi+json, openapi+json-link, openapi-link, swagger-json, swagger-link-json, wadl-link-json, wadl-xml, wsdl and wsdl-link."
  type        = string
  default     = "swagger-link-json"
}

variable "open_api_spec_content_value" {
  description = "The Content from which the API Definition should be imported. When a content_format of *-link-* is specified this must be a URL, otherwise this must be defined inline."
  type        = string
  default     = "http://conferenceapi.azurewebsites.net/?format=json"
}

variable "prefix" {
  description = "The prefix which should be used for all resources in this example"
  type        = string
  default     = "brainboard"
}

variable "tags" {
  description = "Default tags to apply to all resources."
  type        = map(any)
  default = {
    archuuid = "37a17291-a1cc-43c4-b36f-422783ec594e"
    env      = "Development"
  }
}

