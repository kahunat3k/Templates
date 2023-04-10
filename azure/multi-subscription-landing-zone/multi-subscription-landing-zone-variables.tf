# Brainboard auto-generated file.

variable "location_hub" {
  type    = string
  default = "eastus"
}

variable "location_spoke" {
  default = "eastus"
}

variable "public_cert" {
  type    = string
  default = "MIIC5jCCAc6gAwIBAgIISHlcsJpjnuswDQYJKoZIhvcNAQELBQAwETEPMA0GA1UEAxMGVlBOIENBMB4XDTIyMTExNjIwMDkyOVoXDTI1MTExNTIwMDkyOVowETEPMA0GA1UEAxMGVlBOIENBMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAhL9kLYbV+NNM2OtJAT7C8Af+tB+8+bQXHQy0wnPKTLMfGtUA18VRDmO4/IUHDkusoe4TDTpeJoKZGfBJnbS+JUy3oV05eEUi1PoTcGYCveAEBUbbFxo5eg08TIK/A2f4T6bbxfeMm0lPEFkYFJI0norrP4YGiKuW5HQXvrtj7XrHp2Nxdx7prGghW4L9nwEqGTiJO8WuVCVu4tutIghu2cLt/4UudY9CcmwwsjuS6BJ2dE8cVeLJzMwBLwWOE1VaP/5lioLW0uCNx0h2CuhwD9Qxy00xoxCZsIblQB6pmAP1uNCFdV0WljBPjgJBPLTox9RFxpcgk/z2CqpASOGkgQIDAQABo0IwQDAPBgNVHRMBAf8EBTADAQH/MA4GA1UdDwEB/wQEAwIBBjAdBgNVHQ4EFgQU4ABUigtYXHrJJkQtaYDE0hmTw94wDQYJKoZIhvcNAQELBQADggEBAE+HarlC6WtDOZIP9pGvVHc59RvJXFMrSvRqqs1H3pWzJrjCdPTqWxE2uFeTsWuv8AhKADIjSWSMsEBqfc/2GRzoGSeYL3d9tF+9mG1XZ6vcQlfxDcZi945l0cDA2Q1DQOqfbO9YYQvOeE0b6UPsG9Lu16FklHvuTa1qh5RaCIYiqqKcUwv0dOSnoj7E3oWKcsuc/jpnU6ZUrydJrQCxnI5vlMHzQWhghrXNVf1a+fNkfnGynGNR44LOBT/8kpveoVg3jvPzENfjE60mzJNfcEznkDF+PG2G56xw1VyhE8Ulx5sZFj9oJxzFCz1OOEPdXl8/gcPEmac8EifAMi9wZKY="
}

variable "public_key" {
  type    = string
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDDMBQOzfmS70QaparH21jWVlkiPzczur9/FFmsTyoNsLElfXnZOW4gV2VNPrE1+qLANnudFxXKtgm/EK61+waJyK+tXr32VHM2noKc2FnDqAxk29HmrPa2vPJvufTTiNmMrMk4GLxY8kWxh66iTkdGsjAzDV5WY2zmIAlYpSajQbfYA1YaHIi2OmicfpaNLEmogbuy/47+QfIGRiACNnNUOccCuDcXxq6gN3ZJUZAHCQC92O4AlTBXHnfoX0Q1X80RGuo7dGoYc+TyjBSiedNJq32sV25/g7J3GB5ZVX61aIJfZjceZLlkkCWNW9IjO3sgA1DUpc31pqsOhkjk5OKgHf4qBzIG/jUKuGL7CT/JcxxSNGtUvJuUVKcYgDXo+I6mFBA2caM9okGlqGaOqJvW7BkKFZXfoJcJyiLs4mrngIHK6oFo2ziZWWRwk0blbPO0wS+p305e9ziZRmUpf46XIslo7S/WWn0ucY8wAoSPPDpsrg7+Xyg1jJ0s5zuiJgE= marsela@Marselas-MacBook-Pro.local"
}

variable "snet_firewall" {
  type    = string
  default = "10.240.1.0/24"
}

variable "snet_jumphost" {
  type    = string
  default = "10.240.2.0/24"
}

variable "snet_kubernetes" {
  type    = string
  default = "10.3.2.0/24"
}

variable "snet_mi" {
  type    = string
  default = "10.2.1.0/24"
}

variable "snet_monitoring" {
  type    = string
  default = "10.3.1.0/24"
}

variable "snet_vpn" {
  type    = string
  default = "10.240.240.0/24"
}

variable "tags" {
  description = "Default tags to apply to all resources."
  type        = map(any)
  default = {
    archuuid = "d39c1f9c-c61f-48a4-a8a3-edac71e7e94e"
    env      = "Development"
  }
}

variable "vnet_application" {
  type    = string
  default = "10.3.0.0/16"
}

variable "vnet_database" {
  type    = string
  default = "10.2.0.0/16"
}

variable "vnet_hub" {
  type    = string
  default = "10.240.0.0/16"
}

