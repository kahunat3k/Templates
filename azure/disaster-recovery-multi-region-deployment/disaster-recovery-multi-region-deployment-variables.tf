# Brainboard auto-generated file.

variable "hostname" {
  type    = string
  default = "test.com"
}

variable "location" {
  type    = string
  default = "East US"
}

variable "public_key" {
  type    = string
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDDMBQOzfmS70QaparH21jWVlkiPzczur9/FFmsTyoNsLElfXnZOW4gV2VNPrE1+qLANnudFxXKtgm/EK61+waJyK+tXr32VHM2noKc2FnDqAxk29HmrPa2vPJvufTTiNmMrMk4GLxY8kWxh66iTkdGsjAzDV5WY2zmIAlYpSajQbfYA1YaHIi2OmicfpaNLEmogbuy/47+QfIGRiACNnNUOccCuDcXxq6gN3ZJUZAHCQC92O4AlTBXHnfoX0Q1X80RGuo7dGoYc+TyjBSiedNJq32sV25/g7J3GB5ZVX61aIJfZjceZLlkkCWNW9IjO3sgA1DUpc31pqsOhkjk5OKgHf4qBzIG/jUKuGL7CT/JcxxSNGtUvJuUVKcYgDXo+I6mFBA2caM9okGlqGaOqJvW7BkKFZXfoJcJyiLs4mrngIHK6oFo2ziZWWRwk0blbPO0wS+p305e9ziZRmUpf46XIslo7S/WWn0ucY8wAoSPPDpsrg7+Xyg1jJ0s5zuiJgE="
}

variable "region1" {
  type    = string
  default = "East US"
}

variable "region2" {
  type    = string
  default = "West US"
}

variable "tags" {
  description = "Default tags to apply to all resources."
  type        = map(any)
  default = {
    archuuid = "efa5cc2f-0dd6-47fc-89a1-8f78e9c1cd5e"
    env      = "Development"
  }
}

