# Brainboard auto-generated file.

resource "azurerm_resource_group" "net-rg" {
  name     = var.rg_name
  location = var.location

  tags = {
    Name = "Network & security"
    Env  = "Development"
  }
}

resource "azurerm_virtual_network" "vnet" {
  resource_group_name = azurerm_resource_group.net-rg.name
  name                = "brainboard-name"
  location            = var.location

  address_space = [
    "192.168.10.0/27",
  ]

  tags = {
    Name = "Network & security"
    Env  = "Development"
  }
}

resource "azurerm_subnet" "subnet-1" {
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = azurerm_resource_group.net-rg.name
  name                 = "subnet-1"
  address_prefix       = "192.168.10.0/28"
}

resource "azurerm_subnet" "subnet-3" {
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = azurerm_resource_group.net-rg.name
  name                 = "subnet-3"
  address_prefix       = "192.168.10.48/29"
}

resource "azurerm_subnet" "subnet-2" {
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = azurerm_resource_group.net-rg.name
  name                 = "subnet-2"
  address_prefix       = "192.168.10.32/29"
}

resource "azurerm_network_security_group" "default" {
  resource_group_name = azurerm_resource_group.net-rg.name
  name                = "brainboardSecurityGroup"
  location            = var.location

  security_rule {
    source_port_range          = "*"
    source_address_prefix      = "*"
    protocol                   = "tcp"
    priority                   = 100
    name                       = "firewall"
    direction                  = "Inbound"
    destination_port_range     = "*"
    destination_address_prefix = "*"
    access                     = "Allow"
  }

  tags = {
    Name = "Network & security"
    Env  = "Development"
  }
}

