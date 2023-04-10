# Brainboard auto-generated file.

resource "azurerm_resource_group" "default" {
  tags     = merge(var.tags, {})
  name     = var.rg_name
  location = "Central US"
}

resource "azurerm_virtual_network" "default" {
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.default.name
  name                = var.vnet_name
  location            = "Central US"

  address_space = [
    var.vnet_cidr,
  ]
}

resource "azurerm_subnet" "default" {
  virtual_network_name = azurerm_virtual_network.default.name
  resource_group_name  = azurerm_resource_group.default.name
  name                 = var.subnet_name

  address_prefixes = [
    var.subnet_cidr,
  ]
}

resource "azurerm_public_ip" "default" {
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.default.name
  name                = "publicIP"
  location            = "Central US"
  allocation_method   = "Static"
}

resource "azurerm_lb" "default" {
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.default.name
  name                = var.lb_name
  location            = "Central US"

  frontend_ip_configuration {
    public_ip_address_id = azurerm_public_ip.default.id
    name                 = "frontendLB"
  }
}

resource "azurerm_virtual_machine" "bastion" {
  vm_size             = var.vm_size
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.default.name
  name                = var.vm_name
  location            = "Central US"

  network_interface_ids = [
    azurerm_network_interface.vm_nic.id,
  ]

  os_profile {
    computer_name  = var.computer_name
    admin_username = var.admin_user
    admin_password = var.admin_password
  }

  storage_os_disk {
    name              = "osDisk"
    managed_disk_type = "Standard_LRS"
    create_option     = "FromImage"
    caching           = "ReadWrite"
  }
}

resource "azurerm_network_interface" "vm_nic" {
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.default.name
  name                = var.nic_name
  location            = "Central US"

  ip_configuration {
    subnet_id                     = azurerm_subnet.default.id
    private_ip_address_allocation = "Dynamic"
    name                          = "vmIP"
  }
}

