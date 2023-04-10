# Brainboard auto-generated file.

resource "azurerm_app_service" "app-service" {
  tags                = merge(var.tags)
  resource_group_name = azurerm_resource_group.app-service-resource-group.name
  name                = var.app-service-name
  location            = "France Central"
  app_service_plan_id = azurerm_app_service_plan.azurerm_app_service_plan-62b3b490.id
}

resource "azurerm_app_service_plan" "azurerm_app_service_plan-62b3b490" {
  tags                = merge(var.tags)
  resource_group_name = azurerm_resource_group.app-service-resource-group.name
  name                = var.app-service-plan-name
  location            = "France Central"

  sku {
    tier = var.app-service-tier
    size = var.app-service-sku-size
  }
}

