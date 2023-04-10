# Brainboard auto-generated file.

resource "azurerm_resource_group" "resource-group_main" {
  tags     = merge(var.tags, {})
  name     = "rg_main"
  location = var.location
}

resource "azurerm_virtual_network" "virtual_network_main" {
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.resource-group_main.name
  name                = "vnet_main"
  location            = var.location

  address_space = [
    "10.1.0.0/16",
  ]
}

resource "azurerm_subnet" "subnet_keyvault" {
  virtual_network_name = azurerm_virtual_network.virtual_network_main.name
  resource_group_name  = azurerm_resource_group.resource-group_main.name
  name                 = "snet_keyvault"

  address_prefixes = [
    "10.1.1.0/24",
  ]
}

resource "azurerm_subnet" "subnet_vm" {
  virtual_network_name = azurerm_virtual_network.virtual_network_main.name
  resource_group_name  = azurerm_resource_group.resource-group_main.name
  name                 = "snet_vm"

  address_prefixes = [
    "10.1.2.0/24",
  ]
}

resource "azurerm_key_vault" "key_vault" {
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  tags                        = merge(var.tags, {})
  soft_delete_retention_days  = 7
  sku_name                    = "standard"
  resource_group_name         = azurerm_resource_group.resource-group_main.name
  purge_protection_enabled    = false
  name                        = "kv-${random_string.kv_random_string.result}"
  location                    = var.location
  enabled_for_disk_encryption = true

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id
    key_permissions = [
      "Get",
      "Create",
      "List",
    ]
    secret_permissions = [
      "Set",
      "Get",
      "Delete",
      "Purge",
      "Recover",
      "List",
    ]
    storage_permissions = [
      "Get",
      "List",
    ]
  }
}

data "azurerm_client_config" "current" {
}

resource "random_string" "kv_random_string" {

  length  = 8
  upper   = false
  special = false
}

resource "azurerm_key_vault_secret" "key_vault_secret" {
  value        = var.admin_password
  tags         = merge(var.tags, {})
  name         = "vmadminpassword"
  key_vault_id = azurerm_key_vault.key_vault.id
}

resource "azurerm_linux_virtual_machine" "linux_virtual_machine" {
  tags                            = merge(var.tags, {})
  size                            = "Standard_F2"
  resource_group_name             = azurerm_resource_group.resource-group_main.name
  name                            = "vmdemo"
  location                        = var.location
  disable_password_authentication = false
  admin_username                  = "adminuser"
  admin_password                  = azurerm_key_vault_secret.key_vault_secret.value

  network_interface_ids = [
    azurerm_network_interface.network_interface.id,
  ]

  os_disk {
    storage_account_type = "Standard_LRS"
    name                 = "os-disk"
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
  resource_group_name = azurerm_resource_group.resource-group_main.name
  name                = "nic_vm"
  location            = var.location

  ip_configuration {
    subnet_id                     = azurerm_subnet.subnet_vm.id
    private_ip_address_allocation = "Dynamic"
    name                          = "internal"
  }
}

