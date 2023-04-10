# Brainboard auto-generated file.

resource "azurerm_resource_group" "default" {
  tags     = merge(var.tags)
  name     = "rg_sentinel"
  location = var.location
}

resource "azurerm_virtual_network" "default" {
  tags                = merge(var.tags)
  resource_group_name = azurerm_resource_group.default.name
  name                = "vnet_monitoring"
  location            = var.location

  address_space = [
    var.address_space,
  ]
}

resource "azurerm_subnet" "default" {
  virtual_network_name = azurerm_virtual_network.default.name
  resource_group_name  = azurerm_resource_group.default.name
  name                 = "subnet_analytics"

  address_prefixes = [
    "10.0.1.0/24",
  ]
}

