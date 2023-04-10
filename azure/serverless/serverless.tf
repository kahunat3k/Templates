# Brainboard auto-generated file.

resource "azurerm_servicebus_namespace" "servicebus-namespace" {
  sku                 = "Standard"
  resource_group_name = azurerm_resource_group.serverlessRG.name
  name                = "servicebus-namespace"
  location            = "West Europe"

  tags = {
    env      = "development"
    archUUID = "616357bb-69f5-4b84-8cd5-8490b476dfe1"
  }
}

resource "azurerm_servicebus_queue" "azurerm_servicebus_queue-ad7eecbc" {
  resource_group_name = azurerm_resource_group.serverlessRG.name
  namespace_name      = azurerm_servicebus_namespace.servicebus-namespace.name
  name                = "servicebus_queue"
}

resource "azurerm_app_service_plan" "serverless_service_plan" {
  resource_group_name = azurerm_resource_group.serverlessRG.name
  name                = "serverless_service_plan"
  location            = "West Europe"
  kind                = "FunctionApp"

  sku {
    tier = "Dynamic"
    size = "Y1"
  }

  tags = {
    env      = "development"
    archUUID = "616357bb-69f5-4b84-8cd5-8490b476dfe1"
  }
}

resource "azurerm_storage_account" "storageaccount" {
  resource_group_name      = azurerm_resource_group.serverlessRG.name
  name                     = "storageaccount"
  location                 = "West Europe"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

  tags = {
    env      = "development"
    archUUID = "616357bb-69f5-4b84-8cd5-8490b476dfe1"
  }
}

resource "azurerm_app_service_plan" "azurerm_app_service_plan-767af32b" {
  resource_group_name = azurerm_resource_group.serverlessRG.name
  name                = "serverless_service_plan"
  location            = "West Europe"
  kind                = "FunctionApp"

  sku {
    tier = "Dynamic"
    size = "Y1"
  }

  tags = {
    env      = "development"
    archUUID = "616357bb-69f5-4b84-8cd5-8490b476dfe1"
  }
}

resource "azurerm_function_app" "function_app" {
  version                   = "~2"
  storage_connection_string = azurerm_storage_account.storageaccount.primary_connection_string
  resource_group_name       = azurerm_resource_group.serverlessRG.name
  name                      = "functionApp"
  location                  = "West Europe"
  app_service_plan_id       = azurerm_app_service_plan.serverless_service_plan.id

  identity {
    type = "SystemAssigned"
  }

  tags = {
    env      = "development"
    archUUID = "616357bb-69f5-4b84-8cd5-8490b476dfe1"
  }
}

resource "azurerm_app_service_plan" "azurerm_app_service_plan-b5d8e632" {
  resource_group_name = azurerm_resource_group.serverlessRG.name
  name                = "serverless_service_plan"
  location            = "West Europe"
  kind                = "FunctionApp"

  sku {
    tier = "Dynamic"
    size = "Y1"
  }

  tags = {
    env      = "development"
    archUUID = "616357bb-69f5-4b84-8cd5-8490b476dfe1"
  }
}

resource "azurerm_resource_group" "serverlessRG" {
  name     = "serverlessRG"
  location = "West Europe"

  tags = {
    env      = "development"
    archUUID = "616357bb-69f5-4b84-8cd5-8490b476dfe1"
  }
}

resource "azurerm_application_insights" "azurerm_application_insights-8e5f013b" {
  resource_group_name = azurerm_resource_group.serverlessRG.name
  name                = "app-insights"
  location            = "West Europe"
  application_type    = "web"

  tags = {
    env      = "development"
    archUUID = "616357bb-69f5-4b84-8cd5-8490b476dfe1"
  }
}

resource "azurerm_key_vault_secret" "azurerm_key_vault_secret-9fcf6575" {
  value        = base64encode(format("%s:%s", var.username, var.password))
  name         = "Basic--Authentication"
  key_vault_id = azurerm_key_vault.azurerm_key_vault-22488c19.id

  tags = {
    env      = "development"
    archUUID = "616357bb-69f5-4b84-8cd5-8490b476dfe1"
  }
}

resource "azurerm_storage_container" "storage_container_jsons" {
  storage_account_name  = azurerm_storage_account.storageaccount.name
  name                  = "jsons"
  container_access_type = "private"
}

resource "azurerm_key_vault_access_policy" "azurerm_key_vault_access_policy-39f86868" {
  tenant_id    = "616357bb-69f5-4b84-8cd5-8490b476dfe1"
  object_id    = azurerm_function_app.function_app.identity[0].principal_id
  key_vault_id = azurerm_key_vault.azurerm_key_vault-22488c19.id

  key_permissions = [
    "get",
    "list",
  ]

  secret_permissions = [
    "get",
    "list",
  ]
}

resource "azurerm_function_app" "azurerm_function_app-44cdc528" {
  version                   = "~2"
  storage_connection_string = azurerm_storage_account.storageaccount.primary_connection_string
  resource_group_name       = azurerm_resource_group.serverlessRG.name
  name                      = "functionApp"
  location                  = "West Europe"
  app_service_plan_id       = azurerm_app_service_plan.azurerm_app_service_plan-b5d8e632.id

  identity {
    type = "SystemAssigned"
  }

  tags = {
    env      = "development"
    archUUID = "616357bb-69f5-4b84-8cd5-8490b476dfe1"
  }
}

resource "azurerm_key_vault" "azurerm_key_vault-22488c19" {
  tenant_id                   = "616357bb-69f5-4b84-8cd5-8490b476dfe1"
  sku_name                    = "standard"
  resource_group_name         = azurerm_resource_group.serverlessRG.name
  name                        = "keyvault"
  location                    = "West Europe"
  enabled_for_disk_encryption = true

  access_policy {
    tenant_id = "616357bb-69f5-4b84-8cd5-8490b476dfe1"
    object_id = "616357bb-69f5-4b84-8cd5-8490b476dfe1"
    key_permissions = [
      "get",
      "create",
      "delete",
      "list",
    ]
    secret_permissions = [
      "get",
      "set",
      "delete",
      "list",
    ]
  }

  lifecycle {
  }

  tags = {
    env      = "development"
    archUUID = "616357bb-69f5-4b84-8cd5-8490b476dfe1"
  }
}

resource "azurerm_function_app" "azurerm_function_app-832c3f0c" {
  version                   = "~2"
  storage_connection_string = azurerm_storage_account.storageaccount.primary_connection_string
  resource_group_name       = azurerm_resource_group.serverlessRG.name
  name                      = "functionApp"
  location                  = "West Europe"
  app_service_plan_id       = azurerm_app_service_plan.azurerm_app_service_plan-767af32b.id

  identity {
    type = "SystemAssigned"
  }

  tags = {
    env      = "development"
    archUUID = "616357bb-69f5-4b84-8cd5-8490b476dfe1"
  }
}

