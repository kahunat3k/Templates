# Brainboard auto-generated file.

resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.location
}

resource "azurerm_storage_account" "default" {
  resource_group_name      = azurerm_resource_group.rg.name
  name                     = "backend${lower(random_id.storage-name-suffix.hex)}"
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "default" {
  storage_account_name  = azurerm_storage_account.default.name
  name                  = "blob"
  container_access_type = "private"
}

resource "azurerm_storage_queue" "default" {
  storage_account_name = azurerm_storage_account.default.name
  name                 = "queue"
}

resource "azurerm_storage_blob" "default" {
  type                   = "Block"
  storage_container_name = azurerm_storage_container.default.name
  storage_account_name   = azurerm_storage_account.default.name
  name                   = "backend"
}

resource "random_id" "storage-name-suffix" {

  byte_length = 8
}

