# Brainboard auto-generated file.

resource "azurerm_resource_group" "resource-group_hub" {
  tags     = merge(var.tags, {})
  name     = "rg_hub"
  location = var.location
}

resource "azurerm_resource_group" "resource-group_spoke" {
  tags     = merge(var.tags, {})
  name     = "rg_spoke"
  location = var.location
}

resource "azurerm_virtual_network" "virtual_network_hub" {
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.resource-group_hub.name
  name                = "vnet_hub"
  location            = var.location

  address_space = [
    var.vnet_hub_addr_space,
  ]
}

resource "azurerm_virtual_network" "virtual_network_spoke" {
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.resource-group_spoke.name
  name                = "vnet_spoke"
  location            = var.location

  address_space = [
    var.vnet_spoke_addr_space,
  ]
}

resource "azurerm_virtual_network_peering" "virtual_network_peering" {
  virtual_network_name         = azurerm_virtual_network.virtual_network_hub.name
  resource_group_name          = azurerm_resource_group.resource-group_hub.name
  remote_virtual_network_id    = azurerm_virtual_network.virtual_network_spoke.id
  name                         = "peerhubtospoke"
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

resource "azurerm_subnet" "subnet_firewall" {
  virtual_network_name = azurerm_virtual_network.virtual_network_hub.name
  resource_group_name  = azurerm_resource_group.resource-group_hub.name
  name                 = "AzureFirewallSubnet"

  address_prefixes = [
    var.snet_firewall_addr_space,
  ]
}

resource "azurerm_subnet" "subnet_jumphost" {
  virtual_network_name = azurerm_virtual_network.virtual_network_hub.name
  resource_group_name  = azurerm_resource_group.resource-group_hub.name
  name                 = "JumphostSubnet"

  address_prefixes = [
    var.snet_jumphost_addr_space,
  ]
}

resource "azurerm_subnet" "subnet_vpn" {
  virtual_network_name = azurerm_virtual_network.virtual_network_hub.name
  resource_group_name  = azurerm_resource_group.resource-group_hub.name
  name                 = "GatewaySubnet"

  address_prefixes = [
    var.snet_vpn_addr_space,
  ]
}

resource "azurerm_subnet" "subnet_pe" {
  virtual_network_name = azurerm_virtual_network.virtual_network_spoke.name
  resource_group_name  = azurerm_resource_group.resource-group_spoke.name
  name                 = "PeSubnet"

  address_prefixes = [
    var.snet_pe_addr_space,
  ]
}

resource "azurerm_subnet" "subnet_cluster" {
  virtual_network_name = azurerm_virtual_network.virtual_network_spoke.name
  resource_group_name  = azurerm_resource_group.resource-group_spoke.name
  name                 = "ClusterSubnet"

  address_prefixes = [
    var.snet_cluster_addr_space,
  ]
}

resource "azurerm_subnet" "subnet_ag" {
  virtual_network_name = azurerm_virtual_network.virtual_network_spoke.name
  resource_group_name  = azurerm_resource_group.resource-group_spoke.name
  name                 = "ApplicationGatewaySubnet"

  address_prefixes = [
    var.snet_ag_addr_space,
  ]
}

resource "azurerm_subnet" "subnet_database" {
  virtual_network_name = azurerm_virtual_network.virtual_network_spoke.name
  resource_group_name  = azurerm_resource_group.resource-group_spoke.name
  name                 = "DbSubnet"

  address_prefixes = [
    var.snet_database_addr_space,
  ]

  delegation {
    name = " fs"
    service_delegation {
      name = "Microsoft.DBforMySQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}

resource "azurerm_firewall" "firewall" {
  tags                = merge(var.tags, {})
  sku_tier            = "Premium"
  sku_name            = "AZFW_VNet"
  resource_group_name = azurerm_resource_group.resource-group_hub.name
  name                = "productionfirewall"
  location            = var.location
  firewall_policy_id  = azurerm_firewall_policy.firewall_policy.id

  ip_configuration {
    subnet_id            = azurerm_subnet.subnet_firewall.id
    public_ip_address_id = azurerm_public_ip.public_ip_app.id
    name                 = "configuration"
  }
}

resource "azurerm_public_ip" "public_ip_app" {
  tags                = merge(var.tags, {})
  sku                 = "Standard"
  resource_group_name = azurerm_resource_group.resource-group_hub.name
  name                = "pip_firewall"
  location            = var.location
  allocation_method   = "Static"
}

resource "azurerm_firewall_policy" "firewall_policy" {
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.resource-group_hub.name
  name                = "firewallpolicy"
  location            = var.location
}

resource "azurerm_firewall_policy_rule_collection_group" "firewall_policy_rule_collection_group" {
  priority           = 100
  name               = "fwpolicy_rcg"
  firewall_policy_id = azurerm_firewall_policy.firewall_policy.id

  nat_rule_collection {
    priority = 100
    name     = "natrule_apgw"
    action   = "Dnat"
    rule {
      translated_port     = 80
      translated_address  = var.app_gateway_fe_ip
      name                = "rule_apgw"
      destination_address = var.demo_public_ip
      destination_ports = [
        "80",
      ]
      protocols = [
        "TCP",
      ]
      source_addresses = [
        "*",
      ]
    }
  }

  network_rule_collection {
    priority = 200
    name     = "net_rule"
    action   = "Allow"
    rule {
      name = "network_rule_collection1_rule1"
      destination_addresses = [
        var.app_gateway_fe_ip,
      ]
      destination_ports = [
        "80",
        "443",
      ]
      protocols = [
        "TCP",
      ]
      source_addresses = [
        var.jumphost_ip,
      ]
    }
  }
}

resource "azurerm_public_ip" "public_ip_vpn" {
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.resource-group_hub.name
  name                = "pip_vpn"
  location            = var.location
  allocation_method   = "Dynamic"
}

resource "azurerm_virtual_network_gateway" "virtual_network_gateway" {
  type                = "Vpn"
  tags                = merge(var.tags, {})
  sku                 = "Standard"
  resource_group_name = azurerm_resource_group.resource-group_hub.name
  name                = "p2s-vpn"
  location            = var.location

  ip_configuration {
    subnet_id                     = azurerm_subnet.subnet_vpn.id
    public_ip_address_id          = azurerm_public_ip.public_ip_vpn.id
    private_ip_address_allocation = "Dynamic"
    name                          = "gatewayconfig"
  }

  vpn_client_configuration {
    address_space = [
      "10.242.0.0/24",
    ]
    root_certificate {
      public_cert_data = var.public_cert
      name             = "root-cert"
    }
    vpn_auth_types = [
      "Certificate",
    ]
  }
}

resource "azurerm_linux_virtual_machine" "linux_virtual_machine" {
  tags                = merge(var.tags, {})
  size                = "Standard_DS2_v2"
  resource_group_name = azurerm_resource_group.resource-group_hub.name
  name                = "jumpostvm"
  location            = var.location
  admin_username      = "adminuser"

  admin_ssh_key {
    username   = "adminuser"
    public_key = var.public_key
  }

  network_interface_ids = [
    azurerm_network_interface.network_interface.id,
  ]

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  source_image_reference {
    version   = "latest"
    sku       = "20_04-lts-gen2"
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
  }
}

resource "azurerm_network_interface" "network_interface" {
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.resource-group_hub.name
  name                = "jumphostnic"
  location            = var.location

  ip_configuration {
    subnet_id                     = azurerm_subnet.subnet_jumphost.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.jumphost_ip
    name                          = "internal"
  }
}

resource "azurerm_application_gateway" "application_gateway" {
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.resource-group_spoke.name
  name                = "appgateway"
  location            = var.location

  backend_address_pool {
    name = "kubernetes"
  }

  backend_http_settings {
    request_timeout       = 60
    protocol              = "Http"
    port                  = 80
    name                  = "demo-bhs"
    cookie_based_affinity = "Disabled"
  }

  frontend_ip_configuration {
    subnet_id                     = azurerm_subnet.subnet_ag.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.app_gateway_fe_ip
    name                          = "fe-config"
  }

  frontend_port {
    port = 80
    name = "fe-port"
  }

  gateway_ip_configuration {
    subnet_id = azurerm_subnet.subnet_ag.id
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
    backend_address_pool_name  = "kubernetes"
  }

  sku {
    tier     = "Standard"
    name     = "Standard_Small"
    capacity = 2
  }
}

resource "azurerm_mysql_flexible_server" "mysql_flexible_server" {
  tags                   = merge(var.tags, {})
  sku_name               = "GP_Standard_D2ds_v4"
  resource_group_name    = azurerm_resource_group.resource-group_spoke.name
  private_dns_zone_id    = azurerm_private_dns_zone.private_dns_zone.id
  name                   = "demo-fs"
  location               = var.location
  delegated_subnet_id    = azurerm_subnet.subnet_database.id
  backup_retention_days  = 7
  administrator_password = var.admin_pass
  administrator_login    = "mysqladmin"
}

resource "azurerm_private_dns_zone" "private_dns_zone" {
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.resource-group_spoke.name
  name                = "demo.mysql.database.azure.com"
}

resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_zone_virtual_network_link" {
  virtual_network_id    = azurerm_virtual_network.virtual_network_spoke.id
  tags                  = merge(var.tags, {})
  resource_group_name   = azurerm_resource_group.resource-group_spoke.name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone.name
  name                  = "linktovnet"
}

resource "azurerm_kubernetes_cluster" "kubernetes_cluster" {
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.resource-group_spoke.name
  name                = "demo-aks"
  location            = var.location
  dns_prefix          = "brainboard"

  default_node_pool {
    vm_size    = "Standard_D2_v2"
    node_count = 3
    name       = "default"
  }

  identity {
    type = "SystemAssigned"
  }

  ingress_application_gateway {
    gateway_name = azurerm_application_gateway.application_gateway.name
    gateway_id   = azurerm_application_gateway.application_gateway.id
  }
}

resource "azurerm_key_vault" "key_vault" {
  tenant_id           = data.azurerm_client_config.current.tenant_id
  tags                = merge(var.tags, {})
  sku_name            = "standard"
  resource_group_name = azurerm_resource_group.resource-group_spoke.name
  name                = "kvdemo"
  location            = var.location
}

data "azurerm_client_config" "current" {
}

resource "azurerm_private_endpoint" "private_endpoint" {
  tags                = merge(var.tags, {})
  subnet_id           = azurerm_subnet.subnet_pe.id
  resource_group_name = azurerm_resource_group.resource-group_spoke.name
  name                = "pe_keyvault"
  location            = var.location

  private_service_connection {
    private_connection_resource_id = azurerm_key_vault.key_vault.id
    name                           = "connectiontokv"
    is_manual_connection           = false
    subresource_names = [
      "Vault",
    ]
  }
}

