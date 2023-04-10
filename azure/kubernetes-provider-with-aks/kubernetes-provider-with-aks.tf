# Brainboard auto-generated file.

resource "azurerm_resource_group" "resource-group" {
  tags     = merge(var.tags, {})
  name     = "rg-kube"
  location = var.location
}

resource "azurerm_virtual_network" "virtual_network" {
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.resource-group.name
  name                = "vnet-kube"
  location            = var.location

  address_space = [
    var.vnet_main_addrspace,
  ]
}

resource "azurerm_subnet" "subnet_kube" {
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  resource_group_name  = azurerm_resource_group.resource-group.name
  name                 = "KubernetesSubnet"

  address_prefixes = [
    var.snet_kube_prefix,
  ]
}

resource "azurerm_kubernetes_cluster" "kubernetes_cluster" {
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.resource-group.name
  name                = "example"
  location            = var.location
  dns_prefix          = "exampleaks1"

  default_node_pool {
    vm_size    = "Standard_D2_v2"
    node_count = 1
    name       = "default"
  }

  identity {
    type = "SystemAssigned"
  }

  ingress_application_gateway {
    gateway_name = azurerm_application_gateway.application_gateway_c_c.name
    gateway_id   = azurerm_application_gateway.application_gateway_c_c.id
  }
}

resource "kubernetes_namespace" "namespace" {

  metadata {
    name = "nginx"
  }

}

resource "kubernetes_deployment" "deployment" {

  metadata {
    name      = "nginx"
    namespace = kubernetes_namespace.namespace.metadata.0.name
  }
  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "MyTestApp"
      }
    }
    template {
      metadata {
        labels = {
          app = "MyTestApp"
        }
      }
      spec {
        container {
          image = "nginx"
          name  = "nginx-container"
          port {
            container_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "service" {

  metadata {
    name      = "nginx"
    namespace = kubernetes_namespace.namespace.metadata.0.name
  }
  spec {
    selector = {
      app = kubernetes_deployment.deployment.spec.0.template.0.metadata.0.labels.app
    }
    type = "NodePort"
    port {
      node_port   = 30201
      port        = 80
      target_port = 80
    }
  }
}

resource "azurerm_application_gateway" "application_gateway_c_c" {
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.resource-group.name
  name                = "appgateway_demo"
  location            = var.location

  backend_address_pool {
    name = local.backend_address_pool_name
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
    public_ip_address_id = azurerm_public_ip.public_ip_30_c_c.id
    name                 = local.frontend_ip_configuration_name
  }

  frontend_port {
    port = 80
    name = local.frontend_port_name
  }

  gateway_ip_configuration {
    subnet_id = azurerm_subnet.subnet_appgateway.id
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

resource "azurerm_public_ip" "public_ip_30_c_c" {
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.resource-group.name
  name                = "pip-kubernetes"
  location            = var.location
  allocation_method   = "Dynamic"
}

resource "azurerm_subnet" "subnet_appgateway" {
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  resource_group_name  = azurerm_resource_group.resource-group.name
  name                 = "GatewaySubnet"

  address_prefixes = [
    var.snet_gateway_prefix,
  ]
}

resource "azurerm_subnet" "subnet_db" {
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  resource_group_name  = azurerm_resource_group.resource-group.name
  name                 = "DatabaseSubnet"

  address_prefixes = [
    var.snet_database_prefix,
  ]
}

resource "azurerm_mariadb_server" "mariadb_server" {
  version                       = "10.2"
  tags                          = merge(var.tags, {})
  storage_mb                    = 5120
  ssl_enforcement_enabled       = true
  sku_name                      = "B_Gen5_2"
  resource_group_name           = azurerm_resource_group.resource-group.name
  public_network_access_enabled = false
  name                          = "mariadb-demo"
  location                      = var.location
  geo_redundant_backup_enabled  = false
  backup_retention_days         = 7
  auto_grow_enabled             = true
  administrator_login_password  = var.db_pass
  administrator_login           = var.db_admin
}

resource "azurerm_mariadb_database" "mariadb_database" {
  server_name         = azurerm_mariadb_server.mariadb_server.id
  resource_group_name = azurerm_resource_group.resource-group.name
  name                = "mariadb_database"
  collation           = "utf8_general_ci"
  charset             = "utf8"
}

