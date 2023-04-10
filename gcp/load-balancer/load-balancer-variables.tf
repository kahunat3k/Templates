# Brainboard auto-generated file.

variable "address" {
  description = "IP address self link"
  type        = string
  default     = "null"
}

variable "cdn" {
  description = "Set to `true` to enable cdn on backend."
  type        = bool
  default     = false
}

variable "certificate" {
  description = "Content of the SSL certificate. Required if `ssl` is `true` and `ssl_certificates` is empty."
  type        = string
  default     = "null"
}

variable "create_address" {
  description = "Create a new global address"
  type        = bool
  default     = true
}

variable "create_url_map" {
  description = "Set to `false` if url_map variable is provided."
  type        = bool
  default     = true
}

variable "firewall_networks" {
  description = "Names of the networks to create firewall rules in"
  type        = list
  default     = ["default"]
}

variable "http_forward" {
  description = "Set to `false` to disable HTTP port 80 forward"
  type        = bool
  default     = true
}

variable "https_redirect" {
  description = "Set to `true` to enable https redirect on the lb."
  type        = bool
  default     = false
}

variable "ip_version" {
  description = "IP version for the Global address (IPv4 or v6)"
  type        = string
  default     = "IPV4"
}

variable "managed_ssl_certificate_domains" {
  description = "Create Google-managed SSL certificates for specified domains. Requires `ssl` to be set to `true` and `use_ssl_certificates` set to `false`."
  type        = list
  default     = []
}

variable "name" {
  description = "Name for the forwarding rule and prefix for supporting resources"
  type        = string
  default     = "brainboard"
}

variable "private_key" {
  description = "Content of the private SSL key. Required if `ssl` is `true` and `ssl_certificates` is empty."
  type        = string
  default     = "null"
}

variable "quic" {
  description = "Set to `true` to enable QUIC support"
  type        = bool
  default     = false
}

variable "security_policy" {
  description = "The resource URL for the security policy to associate with the backend service"
  type        = string
  default     = "null"
}

variable "ssl" {
  description = "Set to `true` to enable SSL support, requires variable `ssl_certificates` - a list of self_link certs"
  type        = bool
  default     = false
}

variable "ssl_certificates" {
  description = "SSL cert self_link list. Required if `ssl` is `true` and no `private_key` and `certificate` is provided."
  type        = list
  default     = []
}

variable "ssl_policy" {
  description = "Selfink to SSL Policy"
  type        = string
  default     = "null"
}

variable "tags" {
  description = "Default tags to apply to all resources."
  type        = map(any)
  default = {
    archuuid = "4fe5743f-adb7-47a2-98bc-f68eacc1172a"
    env      = "Development"
  }
}

variable "target_service_accounts" {
  description = "List of target service accounts for health check firewall rule. Exactly one of target_tags or target_service_accounts should be specified."
  type        = list
  default     = []
}

variable "target_tags" {
  description = "List of target tags for health check firewall rule. Exactly one of target_tags or target_service_accounts should be specified."
  type        = list
  default     = []
}

variable "url_map" {
  description = "The url_map resource to use. Default is to send all traffic to first backend."
  type        = string
  default     = "null"
}

variable "use_ssl_certificates" {
  description = "If true, use the certificates provided by `ssl_certificates`, otherwise, create cert from `private_key` and `certificate`"
  type        = bool
  default     = false
}

