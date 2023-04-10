# Brainboard auto-generated file.

resource "random_pet" "rg_name" {

  prefix = var.name_prefix
}

resource "azurerm_resource_group" "default" {
  name     = "random_pet.rg_name.id"
  location = "eastus"

  tags = {
    env      = "Development"
    archUUID = "e1bd30fa-4551-459d-a8e0-6adf0ad25e02"
  }
}

resource "azurerm_virtual_network" "virtual_network_3" {
  resource_group_name = azurerm_resource_group.default.name
  name                = "${var.name_prefix}-vnet"
  location            = "eastus"

  address_space = [
    var.vnet_cidr,
  ]

  tags = {
    env      = "Development"
    archUUID = "e1bd30fa-4551-459d-a8e0-6adf0ad25e02"
  }
}

resource "azurerm_network_security_group" "default" {
  resource_group_name = azurerm_resource_group.default.name
  name                = "${var.name_prefix}-nsg"
  location            = "eastus"

  security_rule {
    source_port_range          = "*"
    source_address_prefix      = "*"
    protocol                   = "Tcp"
    priority                   = 100
    name                       = "rule1"
    direction                  = "Inbound"
    destination_port_range     = "*"
    destination_address_prefix = "*"
    description                = "Default Allow NSG rule"
    access                     = "Allow"
  }

  tags = {
    env      = "Development"
    archUUID = "e1bd30fa-4551-459d-a8e0-6adf0ad25e02"
  }
}

resource "azurerm_subnet" "default" {
  virtual_network_name = azurerm_virtual_network.virtual_network_3.name
  resource_group_name  = azurerm_resource_group.default.name
  name                 = "${var.name_prefix}-subnet"

  address_prefixes = [
    var.subnet_cidr,
  ]

  delegation {
    name = "fs"
    service_delegation {
      name = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }

  service_endpoints = [
    "Microsoft.Storage",
  ]
}

resource "azurerm_subnet_network_security_group_association" "subnet_network_security_group_association_6" {
  subnet_id                 = azurerm_subnet.default.id
  network_security_group_id = azurerm_network_security_group.default.id
}

resource "azurerm_private_dns_zone" "default" {
  resource_group_name = azurerm_resource_group.default.name
  name                = "${var.name_prefix}-pdz.postgres.database.azure.com"

  depends_on = [
    azurerm_subnet_network_security_group_association.subnet_network_security_group_association_6,
  ]

  tags = {
    env      = "Development"
    archUUID = "e1bd30fa-4551-459d-a8e0-6adf0ad25e02"
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "default" {
  virtual_network_id    = azurerm_virtual_network.virtual_network_3.id
  resource_group_name   = azurerm_resource_group.default.name
  private_dns_zone_name = azurerm_private_dns_zone.default.name
  name                  = "${var.name_prefix}-pdzvnetlink.com"

  tags = {
    env      = "Development"
    archUUID = "e1bd30fa-4551-459d-a8e0-6adf0ad25e02"
  }
}

resource "azurerm_postgresql_flexible_server" "default" {
  zone                   = "1"
  version                = "13"
  storage_mb             = 32768
  sku_name               = "GP_Standard_D2s_v3"
  resource_group_name    = azurerm_resource_group.default.name
  private_dns_zone_id    = azurerm_private_dns_zone.default.id
  name                   = "${var.name_prefix}-server"
  location               = "eastus"
  delegated_subnet_id    = azurerm_subnet.default.id
  backup_retention_days  = 7
  administrator_password = var.server_password
  administrator_login    = var.server_login

  depends_on = [
    azurerm_private_dns_zone_virtual_network_link.default,
  ]

  tags = {
    env      = "Development"
    archUUID = "e1bd30fa-4551-459d-a8e0-6adf0ad25e02"
  }
}

