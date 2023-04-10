# Brainboard auto-generated file.

resource "azurerm_resource_group" "resource-group_network" {
  tags     = merge(var.tags, {})
  name     = "rg-network"
  location = var.location
}

resource "azurerm_resource_group" "resource-group_governance" {
  tags     = merge(var.tags, {})
  name     = "rg-governance"
  location = var.location
}

resource "azurerm_resource_group" "resource-group_automation" {
  tags     = merge(var.tags, {})
  name     = "rg-automationdb"
  location = var.location
}

resource "azurerm_resource_group" "resource-group_service" {
  tags     = merge(var.tags, {})
  name     = "rg-servicelayer"
  location = var.location
}

resource "azurerm_virtual_network" "virtual_network" {
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.resource-group_network.name
  name                = "vnet-main"
  location            = var.location

  address_space = [
    "10.100.0.0/16",
  ]
}

resource "azurerm_network_security_group" "network_security_group" {
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.resource-group_network.name
  name                = "nsg-data"
  location            = var.location

  security_rule {
    source_port_range          = "*"
    source_address_prefix      = "82.102.23.23"
    protocol                   = "Tcp"
    priority                   = 100
    name                       = "ssh"
    direction                  = "Inbound"
    destination_port_range     = "22"
    destination_address_prefix = "*"
    access                     = "Allow"
  }
}

resource "azurerm_route_table" "route_table" {
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.resource-group_network.name
  name                = "example-route-table"
  location            = var.location
}

resource "azurerm_network_watcher" "network_watcher_9" {
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.resource-group_monitoring.name
  name                = "production-nwwatcher"
  location            = var.location
}

resource "azurerm_security_center_workspace" "security_center_workspace" {
  workspace_id = azurerm_log_analytics_workspace.log_analytics_workspace.id
  scope        = data.azurerm_subscription.current.id
}

resource "azurerm_log_analytics_workspace" "log_analytics_workspace" {
  tags                = merge(var.tags, {})
  sku                 = "PerGB2018"
  resource_group_name = azurerm_resource_group.resource-group_monitoring.name
  name                = "tfex-security-workspace"
  location            = var.location
}

resource "azurerm_resource_group" "resource-group_monitoring" {
  tags     = merge(var.tags, {})
  name     = "rg-monitoring"
  location = var.location
}

data "azurerm_subscription" "current" {
}

resource "azurerm_cosmosdb_mongo_database" "cosmosdb_mongo_database" {
  throughput          = 400
  resource_group_name = azurerm_resource_group.resource-group_automation.name
  name                = "tfex-cosmos-mongo-db"
  account_name        = azurerm_cosmosdb_account.cosmosdb_account.id
}

resource "azurerm_cosmosdb_account" "cosmosdb_account" {
  tags                      = merge(var.tags, {})
  resource_group_name       = azurerm_resource_group.resource-group_automation.name
  offer_type                = "Standard"
  name                      = "tfex-cosmos-db-${random_integer.ri.result}"
  location                  = var.location
  kind                      = "MongoDB"
  enable_automatic_failover = true

  capabilities {
    name = "EnableAggregationPipeline"
  }
  capabilities {
    name = "mongoEnableDocLevelTTL"
  }
  capabilities {
    name = "MongoDBv3.4"
  }
  capabilities {
    name = "EnableMongo"
  }

  consistency_policy {
    max_staleness_prefix    = 100000
    max_interval_in_seconds = 300
    consistency_level       = "BoundedStaleness"
  }

  geo_location {
    location          = "eastus"
    failover_priority = 1
  }
  geo_location {
    location          = "westus"
    failover_priority = 1
  }
}

resource "random_integer" "ri" {

  min = 10000
  max = 99999
}

resource "azurerm_purview_account" "purview_account" {
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.resource-group_governance.name
  name                = "example"
  location            = var.location

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_key_vault" "key_vault" {
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  tags                        = merge(var.tags, {})
  sku_name                    = "standard"
  resource_group_name         = azurerm_resource_group.resource-group_governance.name
  name                        = "examplekeyvault"
  location                    = var.location
  enabled_for_disk_encryption = true

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id
    key_permissions = [
      "Get",
    ]
    secret_permissions = [
      "Get",
    ]
    storage_permissions = [
      "Get",
    ]
  }

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
  }
}

data "azurerm_client_config" "current" {
}

resource "azurerm_api_management" "api_management_20" {
  tags                = merge(var.tags, {})
  sku_name            = "Developer_1"
  resource_group_name = azurerm_resource_group.resource-group_governance.name
  publisher_name      = "My Company"
  publisher_email     = "company@brainboard.co"
  name                = "example-apim"
  location            = var.location
}

resource "azurerm_data_share_account" "data_share_account" {
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.resource-group_governance.name
  name                = "example-dsa"
  location            = var.location

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_data_share" "data_share" {
  name       = "example_dss"
  kind       = "CopyBased"
  account_id = azurerm_data_share_account.data_share_account.id
}

resource "azurerm_linux_function_app" "linux_function_app_23" {
  tags                       = merge(var.tags, {})
  storage_account_name       = azurerm_storage_account.storage_account.name
  storage_account_access_key = azurerm_storage_account.storage_account.primary_access_key
  service_plan_id            = azurerm_service_plan.service_plan.id
  resource_group_name        = azurerm_resource_group.resource-group_service.name
  name                       = "provisioning"
  location                   = var.location

  site_config {
  }
}

resource "azurerm_linux_function_app" "linux_function_app_24" {
  tags                       = merge(var.tags, {})
  storage_account_name       = azurerm_storage_account.storage_account.name
  storage_account_access_key = azurerm_storage_account.storage_account.primary_access_key
  service_plan_id            = azurerm_service_plan.service_plan.id
  resource_group_name        = azurerm_resource_group.resource-group_service.name
  name                       = "product-onboarding"
  location                   = var.location

  site_config {
  }
}

resource "azurerm_storage_account" "storage_account" {
  tags                     = merge(var.tags, {})
  resource_group_name      = azurerm_resource_group.resource-group_service.name
  name                     = "linuxfunctionappsa"
  min_tls_version          = "TLS1_2"
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_service_plan" "service_plan" {
  tags                = merge(var.tags, {})
  sku_name            = "Y1"
  resource_group_name = azurerm_resource_group.resource-group_service.name
  os_type             = "Linux"
  name                = "example-app-service-plan"
  location            = var.location
}

resource "azurerm_linux_function_app" "linux_function_app_27" {
  tags                       = merge(var.tags, {})
  storage_account_name       = azurerm_storage_account.storage_account.name
  storage_account_access_key = azurerm_storage_account.storage_account.primary_access_key
  service_plan_id            = azurerm_service_plan.service_plan.id
  resource_group_name        = azurerm_resource_group.resource-group_service.name
  name                       = "agnostic-ingestion"
  location                   = var.location

  site_config {
  }
}

resource "azurerm_linux_function_app" "linux_function_app_28" {
  tags                       = merge(var.tags, {})
  storage_account_name       = azurerm_storage_account.storage_account.name
  storage_account_access_key = azurerm_storage_account.storage_account.primary_access_key
  service_plan_id            = azurerm_service_plan.service_plan.id
  resource_group_name        = azurerm_resource_group.resource-group_service.name
  name                       = "metadata"
  location                   = var.location

  site_config {
  }
}

resource "azurerm_linux_function_app" "linux_function_app_29" {
  tags                       = merge(var.tags, {})
  storage_account_name       = azurerm_storage_account.storage_account.name
  storage_account_access_key = azurerm_storage_account.storage_account.primary_access_key
  service_plan_id            = azurerm_service_plan.service_plan.id
  resource_group_name        = azurerm_resource_group.resource-group_service.name
  name                       = "access-provisioning"
  location                   = var.location

  site_config {
  }
}

resource "azurerm_linux_function_app" "linux_function_app_30" {
  tags                       = merge(var.tags, {})
  storage_account_name       = azurerm_storage_account.storage_account.name
  storage_account_access_key = azurerm_storage_account.storage_account.primary_access_key
  service_plan_id            = azurerm_service_plan.service_plan.id
  resource_group_name        = azurerm_resource_group.resource-group_service.name
  name                       = "lifecycle"
  location                   = var.location

  site_config {
  }
}

resource "azurerm_resource_group" "resource-group_container" {
  tags     = merge(var.tags, {})
  name     = "rg-containers"
  location = var.location
}

resource "azurerm_container_registry" "container_registry" {
  tags                = merge(var.tags, {})
  sku                 = "Premium"
  resource_group_name = azurerm_resource_group.resource-group_container.name
  name                = "containerRegistry1"
  location            = var.location
  admin_enabled       = false
}

