# Brainboard auto-generated file.

resource "azurerm_resource_group" "default-rg" {
  name     = "${var.prefix}-resources"
  location = var.location

  tags = {
    env      = "Staging"
    archUUID = "358e6e70-42f0-48d2-a0b2-0c2618bbd2c1"
  }
}

resource "azurerm_api_management" "apim_service" {
  sku_name            = "Developer_1"
  resource_group_name = azurerm_resource_group.default-rg.name
  publisher_name      = "Brainboard Publisher"
  publisher_email     = "contact@brainboard.co"
  name                = "${var.prefix}-apim-service"
  location            = var.location

  policy {
    xml_content = <<XML
    <policies>
      <inbound />
      <backend />
      <outbound />
      <on-error />
    </policies>
XML
  }

  tags = {
    Name = "Brainboard RG"
    Env  = "Development"
  }
}

resource "azurerm_api_management_api" "mapi" {
  revision            = "1"
  resource_group_name = azurerm_resource_group.default-rg.name
  path                = "Brainboard"
  name                = "${var.prefix}-api"
  display_name        = "${var.prefix}-api"
  description         = "Brainboard management API"
  api_management_name = azurerm_api_management.apim_service.name

  import {
    content_value  = var.open_api_spec_content_value
    content_format = var.open_api_spec_content_format
  }

  protocols = [
    "http",
    "https",
  ]
}

resource "azurerm_api_management_product" "product" {
  subscription_required = true
  resource_group_name   = azurerm_resource_group.default-rg.name
  published             = true
  product_id            = "${var.prefix}-product"
  display_name          = "${var.prefix}-product"
  description           = "Brainboard product"
  approval_required     = false
  api_management_name   = azurerm_api_management.apim_service.name
}

resource "azurerm_api_management_group" "group" {
  resource_group_name = azurerm_resource_group.default-rg.name
  name                = "${var.prefix}-group"
  display_name        = "${var.prefix}-group"
  description         = "Brainboard group"
  api_management_name = azurerm_api_management.apim_service.name
}

resource "azurerm_api_management_product_api" "product_api" {
  resource_group_name = azurerm_resource_group.default-rg.name
  product_id          = azurerm_api_management_product.product.product_id
  api_name            = azurerm_api_management_api.mapi.name
  api_management_name = azurerm_api_management.apim_service.name
}

resource "azurerm_api_management_product_group" "product_group" {
  resource_group_name = azurerm_resource_group.default-rg.name
  product_id          = azurerm_api_management_product.product.product_id
  group_name          = azurerm_api_management_group.group.name
  api_management_name = azurerm_api_management.apim_service.name
}

