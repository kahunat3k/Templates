# Brainboard auto-generated file.

resource "azurerm_resource_group" "app-service-resource-group" {
  tags     = merge(var.tags)
  name     = var.rg_name
  location = "France Central"
}

