# Brainboard auto-generated file.

resource "azurerm_resource_group" "resource-group-main" {
  tags     = merge(var.tags, {})
  name     = "rg-main"
  location = var.location
}

resource "azurerm_cdn_frontdoor_custom_domain" "cdn_frontdoor_custom_domain" {
  name                     = "demo-customdomain"
  host_name                = var.hostname
  dns_zone_id              = azurerm_dns_zone.dns_zone.id
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.cdn_frontdoor_profile.id

  tls {
    minimum_tls_version = "TLS12"
    certificate_type    = "ManagedCertificate"
  }
}

resource "azurerm_dns_zone" "dns_zone" {
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.resource-group-main.name
  name                = "sub-domain.domain.com"
}

resource "azurerm_cdn_frontdoor_profile" "cdn_frontdoor_profile" {
  tags                = merge(var.tags, {})
  sku_name            = "Standard_AzureFrontDoor"
  resource_group_name = azurerm_resource_group.resource-group-main.name
  name                = "demo-profile"
}

resource "azurerm_linux_web_app" "linux_web_app_reg2" {
  tags                = merge(var.tags, {})
  service_plan_id     = azurerm_service_plan.service_plan_region2.id
  resource_group_name = azurerm_resource_group.resource-group-reg2.name
  name                = "webapp-reg2"
  location            = var.region2

  site_config {
  }
}

resource "azurerm_linux_web_app" "linux_web_app_reg1" {
  tags                = merge(var.tags, {})
  service_plan_id     = azurerm_service_plan.service_plan_region1.id
  resource_group_name = azurerm_resource_group.resource-group-reg1.name
  name                = "webapp-reg1"
  location            = var.region1

  site_config {
  }
}

resource "azurerm_service_plan" "service_plan_region2" {
  tags                = merge(var.tags, {})
  sku_name            = "P1v2"
  resource_group_name = azurerm_resource_group.resource-group-reg2.name
  os_type             = "Linux"
  name                = "serviceplan-reg2"
  location            = var.region2
}

resource "azurerm_service_plan" "service_plan_region1" {
  tags                = merge(var.tags, {})
  sku_name            = "P1v2"
  resource_group_name = azurerm_resource_group.resource-group-reg1.name
  os_type             = "Linux"
  name                = "serviceplan-reg1"
  location            = var.region1
}

resource "azurerm_linux_function_app" "linux_function_app_reg1" {
  tags                       = merge(var.tags, {})
  storage_account_name       = azurerm_storage_account.storage_account_reg1.name
  storage_account_access_key = azurerm_storage_account.storage_account_reg1.primary_access_key
  service_plan_id            = azurerm_service_plan.service_plan_region1.id
  resource_group_name        = azurerm_resource_group.resource-group-reg1.name
  name                       = "linux-function-app-reg1"
  location                   = var.region1

  site_config {
  }
}

resource "azurerm_linux_function_app" "linux_function_app_reg2" {
  tags                       = merge(var.tags, {})
  storage_account_name       = azurerm_storage_account.storage_account_reg1.name
  storage_account_access_key = azurerm_storage_account.storage_account_reg1.primary_access_key
  service_plan_id            = azurerm_service_plan.service_plan_region2.id
  resource_group_name        = azurerm_resource_group.resource-group-reg2.name
  name                       = "linux-function-app-reg2"
  location                   = var.region2

  site_config {
  }
}

resource "azurerm_storage_account" "storage_account_reg1" {
  tags                     = merge(var.tags, {})
  resource_group_name      = azurerm_resource_group.resource-group-reg1.name
  name                     = "sareg1"
  min_tls_version          = "TLS1_2"
  location                 = var.region1
  account_tier             = "Standard"
  account_replication_type = "GZRS"
  account_kind             = "StorageV2"
}

resource "azurerm_cosmosdb_account" "cosmosdb_account" {
  tags                      = merge(var.tags, {})
  resource_group_name       = azurerm_resource_group.resource-group-reg1.name
  offer_type                = "Standard"
  name                      = "tfex-cosmos-db-${random_integer.ri.result}"
  location                  = var.region1
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
    failover_priority = 0
  }
}

resource "random_integer" "ri" {

  min = 10000
  max = 99999
}

resource "azurerm_redis_cache" "redis_cache_reg1" {
  tags                = merge(var.tags, {})
  sku_name            = "Premium"
  resource_group_name = azurerm_resource_group.resource-group-reg1.name
  name                = "redis-reg1"
  minimum_tls_version = "1.2"
  location            = var.region1
  family              = "P"
  enable_non_ssl_port = false
  capacity            = 1

  redis_configuration {
    maxmemory_reserved = 2
    maxmemory_policy   = "allkeys-lru"
    maxmemory_delta    = 2
  }
}

resource "azurerm_redis_cache" "redis_cache_reg2" {
  tags                = merge(var.tags, {})
  sku_name            = "Premium"
  resource_group_name = azurerm_resource_group.resource-group-reg2.name
  name                = "redis-reg2"
  minimum_tls_version = "1.2"
  location            = var.region2
  family              = "P"
  enable_non_ssl_port = false
  capacity            = 1

  redis_configuration {
    maxmemory_reserved = 2
    maxmemory_policy   = "allkeys-lru"
    maxmemory_delta    = 2
  }
}

resource "azurerm_resource_group" "resource-group-reg1" {
  tags     = merge(var.tags, {})
  name     = "rg_reg1"
  location = var.region1
}

resource "azurerm_resource_group" "resource-group-reg2" {
  tags     = merge(var.tags, {})
  name     = "rg_reg2"
  location = var.region2
}

resource "azurerm_redis_linked_server" "redis_linked_server" {
  target_redis_cache_name     = azurerm_redis_cache.redis_cache_reg1.name
  server_role                 = "Secondary"
  resource_group_name         = azurerm_resource_group.resource-group-reg1.name
  linked_redis_cache_location = azurerm_redis_cache.redis_cache_reg2.location
  linked_redis_cache_id       = azurerm_redis_cache.redis_cache_reg2.id
}

