# Brainboard auto-generated file.

resource "azurerm_notification_hub" "azurerm_notification_hub-29958348" {
  resource_group_name = azurerm_resource_group.resource-group-c0d2763c.name
  location            = "East US"

  tags = {
    env      = "development"
    archUUID = "f64bd26c-4666-4a52-af57-30ddf85b5bc3"
  }
}

resource "aws_apigatewayv2_api" "aws_apigatewayv2_api-61522778" {

  tags = {
    env      = "development"
    archUUID = "f64bd26c-4666-4a52-af57-30ddf85b5bc3"
  }
}

resource "aws_route53_zone" "aws_route53_zone-b42edd9f" {

  tags = {
    env      = "development"
    archUUID = "f64bd26c-4666-4a52-af57-30ddf85b5bc3"
  }
}

resource "aws_sns_platform_application" "aws_sns_platform_application-bac9b3a0" {
}

resource "aws_sqs_queue" "aws_sqs_queue-d6694809" {

  tags = {
    env      = "development"
    archUUID = "f64bd26c-4666-4a52-af57-30ddf85b5bc3"
  }
}

resource "azurerm_function_app" "azurerm_function_app-0fd0d24c" {
  resource_group_name = azurerm_resource_group.resource-group-c0d2763c.name
  location            = "East US"

  tags = {
    env      = "development"
    archUUID = "f64bd26c-4666-4a52-af57-30ddf85b5bc3"
  }
}

resource "azurerm_storage_blob" "azurerm_storage_blob-123511c3" {
}

resource "azurerm_linux_virtual_machine" "azurerm_linux_virtual_machine-6078e8b3" {
  resource_group_name = azurerm_resource_group.resource-group-c0d2763c.name
  location            = "East US"

  tags = {
    env      = "development"
    archUUID = "f64bd26c-4666-4a52-af57-30ddf85b5bc3"
  }
}

resource "aws_lambda_function" "aws_lambda_function-d2418dfc" {

  tags = {
    env      = "development"
    archUUID = "f64bd26c-4666-4a52-af57-30ddf85b5bc3"
  }
}

resource "aws_lambda_function" "aws_lambda_function-72a563dc" {

  tags = {
    env      = "development"
    archUUID = "f64bd26c-4666-4a52-af57-30ddf85b5bc3"
  }
}

resource "azurerm_eventhub" "azurerm_eventhub-a2fa8f18" {
  resource_group_name = azurerm_resource_group.resource-group-c0d2763c.name
}

resource "aws_instance" "t3a-b2ae8499" {

  tags = {
    env      = "development"
    archUUID = "f64bd26c-4666-4a52-af57-30ddf85b5bc3"
    Name     = "friday demo"
  }
}

resource "aws_lambda_function" "aws_lambda_function-b895edd3" {

  tags = {
    env      = "development"
    archUUID = "f64bd26c-4666-4a52-af57-30ddf85b5bc3"
  }
}

resource "aws_s3_bucket" "aws_s3_bucket-4f024f17" {

  tags = {
    env      = "development"
    archUUID = "f64bd26c-4666-4a52-af57-30ddf85b5bc3"
  }
}

resource "azurerm_virtual_machine" "azurerm_virtual_machine-6e557a41" {
  resource_group_name = azurerm_resource_group.resource-group-c0d2763c.name
  location            = "East US"

  tags = {
    env      = "development"
    archUUID = "f64bd26c-4666-4a52-af57-30ddf85b5bc3"
  }
}

resource "azurerm_resource_group" "resource-group-c0d2763c" {
  location = "East US"

  tags = {
    env      = "development"
    archUUID = "f64bd26c-4666-4a52-af57-30ddf85b5bc3"
  }
}

resource "azurerm_api_management" "azurerm_api_management-c62b2be0" {
  resource_group_name = azurerm_resource_group.resource-group-c0d2763c.name
  location            = "East US"

  tags = {
    env      = "development"
    archUUID = "f64bd26c-4666-4a52-af57-30ddf85b5bc3"
  }
}

resource "azurerm_function_app" "azurerm_function_app-a3334f94" {
  resource_group_name = azurerm_resource_group.resource-group-c0d2763c.name
  location            = "East US"

  tags = {
    env      = "development"
    archUUID = "f64bd26c-4666-4a52-af57-30ddf85b5bc3"
  }
}

resource "azurerm_frontdoor" "azurerm_frontdoor-cffa613b" {
  resource_group_name                          = azurerm_resource_group.resource-group-c0d2763c.name
  location                                     = "East US"
  enforce_backend_pools_certificate_name_check = true

  tags = {
    env      = "development"
    archUUID = "f64bd26c-4666-4a52-af57-30ddf85b5bc3"
  }
}

resource "azurerm_function_app" "azurerm_function_app-f542ba6b" {
  resource_group_name = azurerm_resource_group.resource-group-c0d2763c.name
  location            = "East US"

  tags = {
    env      = "development"
    archUUID = "f64bd26c-4666-4a52-af57-30ddf85b5bc3"
  }
}

