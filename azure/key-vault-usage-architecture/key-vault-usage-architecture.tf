# Brainboard auto-generated file.

resource "azurerm_subnet" "subnet_vm" {
  virtual_network_name = data.azurerm_virtual_network.virtual_network.name
  resource_group_name  = data.azurerm_resource_group.resource_group_main_data.name
  name                 = "snet_vm_kv"

  address_prefixes = [
    "10.1.3.0/24",
  ]
}

resource "azurerm_linux_virtual_machine" "linux_virtual_machine" {
  tags                            = merge(var.tags, {})
  size                            = "Standard_F2"
  resource_group_name             = data.azurerm_resource_group.resource_group_main_data.name
  name                            = "vm_kv"
  location                        = data.azurerm_resource_group.resource_group_main_data.location
  disable_password_authentication = false
  computer_name                   = "vmkv"
  admin_username                  = "adminuser"
  admin_password                  = data.azurerm_key_vault_secret.key_vault_secret.value

  network_interface_ids = [
    azurerm_network_interface.network_interface.id,
  ]

  os_disk {
    storage_account_type = "Standard_LRS"
    name                 = "os-disk-kv"
    caching              = "ReadWrite"
  }

  source_image_reference {
    version   = "latest"
    sku       = "16.04-LTS"
    publisher = "Canonical"
    offer     = "UbuntuServer"
  }
}

resource "azurerm_network_interface" "network_interface" {
  tags                = merge(var.tags, {})
  resource_group_name = data.azurerm_resource_group.resource_group_main_data.name
  name                = "nic_vm_kv"
  location            = data.azurerm_resource_group.resource_group_main_data.location

  ip_configuration {
    subnet_id                     = azurerm_subnet.subnet_vm.id
    private_ip_address_allocation = "Dynamic"
    name                          = "internal"
  }
}

data "azurerm_resource_group" "resource_group_main_data" {
  name = "rg_main"
}

data "azurerm_key_vault_secret" "key_vault_secret" {
  name         = "vmadminpassword"
  key_vault_id = data.azurerm_key_vault.key_vault.id
}

data "azurerm_key_vault" "key_vault" {
  resource_group_name = data.azurerm_resource_group.resource_group_main_data.name
  name                = var.keyvaultname
}

data "azurerm_virtual_network" "virtual_network" {
  resource_group_name = data.azurerm_resource_group.resource_group_main_data.name
  name                = "vnet_main"
}

