# Brainboard auto-generated file.

resource "azurerm_resource_group" "resource-group_main" {
  tags     = merge(var.tags, {})
  name     = "rg-main"
  location = var.location
}

resource "azurerm_virtual_network" "virtual_network_3" {
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.resource-group_main.name
  name                = "vnet-main"
  location            = var.location

  address_space = [
    "10.1.0.0/16",
  ]
}

resource "azurerm_key_vault" "key_vault_main" {
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

resource "azurerm_subnet" "subnet_keyvault" {
  virtual_network_name = azurerm_virtual_network.virtual_network_3.name
  resource_group_name  = azurerm_resource_group.resource-group_main.name
  name                 = "snet_endpoint"

  address_prefixes = [
    "10.1.1.0/24",
  ]
}

resource "azurerm_application_gateway" "application_gateway" {
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.resource-group_main.name
  name                = "appgateway"
  location            = var.location

  backend_address_pool {
    name = "springapp_ap"
    fqdns = [
      azurerm_spring_cloud_app.spring_cloud_app.fqdn,
    ]
  }

  backend_http_settings {
    request_timeout       = 60
    protocol              = "Http"
    port                  = 80
    name                  = "demo-bhs"
    cookie_based_affinity = "Disabled"
  }

  frontend_ip_configuration {
    public_ip_address_id = azurerm_public_ip.public_ip.id
    name                 = "fe-config"
  }

  frontend_port {
    port = 80
    name = "fe-port"
  }

  gateway_ip_configuration {
    subnet_id = azurerm_subnet.subnet_waf.id
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
    backend_address_pool_name  = "springapp_ap"
  }

  sku {
    tier     = "Standard"
    name     = "Standard_Small"
    capacity = 2
  }

  waf_configuration {
    rule_set_version = "3.1"
    rule_set_type    = "OWASP"
    firewall_mode    = "Prevention"
    enabled          = true
    disabled_rule_group {
      rule_group_name = "REQUEST-941-APPLICATION-ATTACK-XSS"
    }
  }
}

resource "azurerm_private_endpoint" "private_endpoint_keyvault" {
  tags                = merge(var.tags, {})
  subnet_id           = azurerm_subnet.subnet_springapps.id
  resource_group_name = azurerm_resource_group.resource-group_main.name
  name                = "pe_keyvault"
  location            = var.location

  private_service_connection {
    private_connection_resource_id = azurerm_key_vault.key_vault_main.id
    name                           = "connectiontokv"
    is_manual_connection           = false
    subresource_names = [
      "Vault",
    ]
  }
}

resource "azurerm_subnet" "subnet_database" {
  virtual_network_name = azurerm_virtual_network.virtual_network_3.name
  resource_group_name  = azurerm_resource_group.resource-group_main.name
  name                 = "snet_database_name"

  address_prefixes = [
    "10.1.2.0/24",
  ]

  delegation {
    name = "Microsoft.DBforMySQL/serversv2"
    service_delegation {
      name = "Microsoft.DBforMySQL/serversv2"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/action",
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}

resource "azurerm_subnet" "subnet_springapps" {
  virtual_network_name = azurerm_virtual_network.virtual_network_3.name
  resource_group_name  = azurerm_resource_group.resource-group_main.name
  name                 = "snet_springapp"

  address_prefixes = [
    "10.1.3.0/24",
  ]
}

resource "azurerm_mysql_database" "mysql_database" {
  server_name         = azurerm_mysql_server.mysql_server.id
  resource_group_name = azurerm_resource_group.resource-group_main.name
  name                = "mysqldb"
  collation           = "utf8_unicode_ci"
  charset             = "utf8"
}

resource "azurerm_mysql_server" "mysql_server" {
  version                           = "5.7"
  tags                              = merge(var.tags, {})
  ssl_minimal_tls_version_enforced  = "TLS1_2"
  ssl_enforcement_enabled           = true
  sku_name                          = "GP_Gen5_2"
  resource_group_name               = azurerm_resource_group.resource-group_main.name
  public_network_access_enabled     = false
  name                              = "sqlserver-app"
  location                          = var.location
  infrastructure_encryption_enabled = false
  geo_redundant_backup_enabled      = false
  backup_retention_days             = 7
  auto_grow_enabled                 = true
  administrator_login_password      = var.admin_password
  administrator_login               = "mysqladminun"
}

resource "azurerm_spring_cloud_app" "spring_cloud_app" {
  service_name        = azurerm_spring_cloud_service.spring_cloud_service.name
  resource_group_name = azurerm_resource_group.resource-group_main.name
  name                = "springcloudapp-main"
}

resource "azurerm_spring_cloud_service" "spring_cloud_service" {
  zone_redundant      = true
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.resource-group_main.name
  name                = "springcloud-service"
  location            = var.location
}

resource "azurerm_private_dns_zone" "private_dns_zone" {
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.resource-group_main.name
  name                = "mydomain.com"
}

resource "azurerm_subnet" "subnet_waf" {
  virtual_network_name = azurerm_virtual_network.virtual_network_3.name
  resource_group_name  = azurerm_resource_group.resource-group_main.name
  name                 = "snet_waf"

  address_prefixes = [
    "10.1.4.0/24",
  ]
}

resource "azurerm_public_ip" "public_ip" {
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.resource-group_main.name
  name                = "pip-ag"
  location            = var.location
  allocation_method   = "Dynamic"
}

resource "azurerm_dns_zone" "dns_zone" {
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.resource-group_main.name
  name                = "publicdns.com"
}

