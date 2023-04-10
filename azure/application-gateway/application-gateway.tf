# Brainboard auto-generated file.

resource "azurerm_resource_group" "resource-group-webapp" {
  tags     = merge(var.tags, {})
  name     = "rg-webapp"
  location = var.location
}

resource "azurerm_virtual_network" "virtual_network_main" {
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.resource-group-webapp.name
  name                = "vnet_ag"
  location            = var.location

  address_space = [
    var.vnet_address,
  ]
}

resource "azurerm_subnet" "subnet_frontend" {
  virtual_network_name = azurerm_virtual_network.virtual_network_main.name
  resource_group_name  = azurerm_resource_group.resource-group-webapp.name
  name                 = "snet_frontend"

  address_prefixes = [
    var.snet_frontend,
  ]
}

resource "azurerm_subnet" "subnet_backend" {
  virtual_network_name = azurerm_virtual_network.virtual_network_main.name
  resource_group_name  = azurerm_resource_group.resource-group-webapp.name
  name                 = "snet_backend"

  address_prefixes = [
    var.snet_backend,
  ]
}

resource "azurerm_public_ip" "public_ip_ag" {
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.resource-group-webapp.name
  name                = "ag_pip"
  location            = var.location
  allocation_method   = "Dynamic"
}

resource "azurerm_application_gateway" "application_gateway" {
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.resource-group-webapp.name
  name                = module.naming.application_gateway.name_unique
  location            = var.location

  backend_address_pool {
    name = "webapp_ap"
    fqdns = [
      azurerm_windows_web_app.windows_web_app.default_hostname,
    ]
  }

  backend_http_settings {
    protocol              = "Http"
    port                  = 80
    name                  = "demo-bhs"
    cookie_based_affinity = "Disabled"
    connection_draining {
      enabled           = true
      drain_timeout_sec = 3600
    }
  }

  frontend_ip_configuration {
    public_ip_address_id = azurerm_public_ip.public_ip_ag.id
    name                 = "fe-config"
  }

  frontend_port {
    port = 80
    name = "fe-port"
  }

  gateway_ip_configuration {
    subnet_id = azurerm_subnet.subnet_frontend.id
    name      = "my-gateway-ip-configuration"
  }

  http_listener {
    protocol                       = "Http"
    name                           = "be-listener"
    frontend_port_name             = "fe-port"
    frontend_ip_configuration_name = "fe-config"
  }

  request_routing_rule {
    rule_type                  = "Basic"
    name                       = "demo-rqrt"
    http_listener_name         = "be-listener"
    backend_http_settings_name = "demo-bhs"
    backend_address_pool_name  = "webapp_ap"
  }

  sku {
    tier     = "Standard"
    name     = "Standard_Small"
    capacity = 2
  }
}

resource "azurerm_windows_web_app" "windows_web_app" {
  tags                = merge(var.tags, {})
  service_plan_id     = azurerm_service_plan.service_plan.id
  resource_group_name = azurerm_resource_group.resource-group-webapp.name
  name                = "windows-webapp-${random_string.example.result}"
  location            = var.location

  site_config {
    use_32_bit_worker = true
    always_on         = false
  }
}

resource "azurerm_service_plan" "service_plan" {
  tags                = merge(var.tags, {})
  sku_name            = "F1"
  resource_group_name = azurerm_resource_group.resource-group-webapp.name
  os_type             = "Windows"
  name                = "serviceplan-webapp-${random_string.example.result}"
  location            = var.location
}

resource "azurerm_subnet" "subnet_db" {
  virtual_network_name = azurerm_virtual_network.virtual_network_main.name
  resource_group_name  = azurerm_resource_group.resource-group-webapp.name
  name                 = "snet_db"

  address_prefixes = [
    var.snet_db,
  ]
}

resource "azurerm_storage_account" "storage_account" {
  tags                     = merge(var.tags, {})
  resource_group_name      = azurerm_resource_group.resource-group-webapp.name
  name                     = "samssql"
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_mssql_database" "mssql_database" {
  zone_redundant  = false
  tags            = merge(var.tags, {})
  sku_name        = "ElasticPool"
  server_id       = azurerm_mssql_server.mssql_server.id
  read_scale      = false
  name            = module.naming.mssql_database.name_unique
  max_size_gb     = 5
  license_type    = "LicenseIncluded"
  elastic_pool_id = azurerm_mssql_elasticpool.mssql_elasticpool.id
  collation       = "SQL_Latin1_General_CP1_CI_AS"
}

resource "azurerm_mssql_server" "mssql_server" {
  version                      = "12.0"
  tags                         = merge(var.tags, {})
  resource_group_name          = azurerm_resource_group.resource-group-webapp.name
  name                         = "sqlserver-webapp-${random_string.example.result}"
  location                     = var.location
  administrator_login_password = var.admin_password
  administrator_login          = "missadministrator"
}

resource "azurerm_mssql_elasticpool" "mssql_elasticpool" {
  tags                = merge(var.tags, {})
  server_name         = azurerm_mssql_server.mssql_server.name
  resource_group_name = azurerm_resource_group.resource-group-webapp.name
  name                = "epool-example"
  max_size_gb         = 50
  location            = var.location

  per_database_settings {
    min_capacity = 0
    max_capacity = 10
  }

  sku {
    tier     = "Standard"
    name     = "StandardPool"
    capacity = 50
  }
}

resource "random_string" "example" {

  length  = 4
  special = false
}

resource "azurerm_subnet" "subnet_monitoring" {
  virtual_network_name = azurerm_virtual_network.virtual_network_main.name
  resource_group_name  = azurerm_resource_group.resource-group-webapp.name
  name                 = "snet_monitoring"

  address_prefixes = [
    var.snet_monitoring,
  ]
}

resource "azurerm_log_analytics_workspace" "log_analytics_workspace" {
  tags                = merge(var.tags, {})
  sku                 = "PerGB2018"
  retention_in_days   = 30
  resource_group_name = azurerm_resource_group.resource-group-webapp.name
  name                = "acctest-01"
  location            = var.location
}

module "naming" {
  source = "Azure/naming/azurerm"

}

