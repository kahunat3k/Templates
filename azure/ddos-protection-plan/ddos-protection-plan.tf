# Brainboard auto-generated file.

resource "azurerm_resource_group" "resource-group_main" {
  tags     = merge(var.tags, {})
  name     = "rg_main"
  location = var.location
}

resource "azurerm_virtual_network" "virtual_network_hub" {
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.resource-group_main.name
  name                = "vnet_main"
  location            = var.location

  address_space = [
    var.vnet_main_addrspace,
  ]

  ddos_protection_plan {
    id     = azurerm_network_ddos_protection_plan.network_ddos_protection_plan_35.id
    enable = true
  }
}

resource "azurerm_subnet" "subnet_ag" {
  virtual_network_name = azurerm_virtual_network.virtual_network_hub.name
  resource_group_name  = azurerm_resource_group.resource-group_main.name
  name                 = "GatewaySubnet"

  address_prefixes = [
    var.snet_gateway_prefix,
  ]
}

resource "azurerm_public_ip" "public_ip" {
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.resource-group_main.name
  name                = "pip_demo"
  location            = var.location
  allocation_method   = "Static"
}

resource "azurerm_application_gateway" "application_gateway" {
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.resource-group_main.name
  name                = "appgateway_demo"
  location            = var.location

  backend_address_pool {
    name = local.backend_address_pool_name
    fqdns = [
      azurerm_linux_web_app.linux_web_app.default_hostname,
    ]
  }

  backend_http_settings {
    request_timeout       = 60
    protocol              = "Http"
    probe_name            = "HttpProbe"
    port                  = 80
    path                  = "/"
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
  }

  frontend_ip_configuration {
    public_ip_address_id = azurerm_public_ip.public_ip.id
    name                 = local.frontend_ip_configuration_name
  }

  frontend_port {
    port = 80
    name = local.frontend_port_name
  }

  gateway_ip_configuration {
    subnet_id = azurerm_subnet.subnet_ag.id
    name      = "my-gateway-ip-configuration"
  }

  http_listener {
    protocol                       = "Http"
    name                           = local.listener_name
    frontend_port_name             = local.frontend_port_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
  }

  request_routing_rule {
    rule_type                  = "Basic"
    name                       = local.request_routing_rule_name
    http_listener_name         = local.listener_name
    backend_http_settings_name = local.http_setting_name
    backend_address_pool_name  = local.backend_address_pool_name
  }

  sku {
    tier     = "WAF"
    name     = "WAF_Medium"
    capacity = 1
  }
}

resource "azurerm_resource_group" "resource-group_application" {
  tags     = merge(var.tags, {})
  name     = "rg_application"
  location = var.location
}

resource "azurerm_service_plan" "service_plan" {
  tags                = merge(var.tags, {})
  sku_name            = "P1v2"
  resource_group_name = azurerm_resource_group.resource-group_application.name
  os_type             = "Linux"
  name                = "serviceplan"
  location            = var.location
}

resource "azurerm_linux_web_app" "linux_web_app" {
  tags                = merge(var.tags, {})
  service_plan_id     = azurerm_service_plan.service_plan.id
  resource_group_name = azurerm_resource_group.resource-group_application.name
  name                = "linuxwebapp"
  location            = var.location

  site_config {
    always_on = true
  }
}

resource "azurerm_network_ddos_protection_plan" "network_ddos_protection_plan_35" {
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.resource-group_main.name
  name                = "ddosplan"
  location            = var.location
}

