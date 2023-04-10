# Brainboard auto-generated file.

resource "azurerm_virtual_wan" "vwan1" {
  resource_group_name               = azurerm_resource_group.region-1-rg-1.name
  office365_local_breakout_category = "OptimizeAndAllow"
  name                              = "vWAN-01"
  location                          = "East US"

  tags = {
    env      = "Development"
    archUUID = "e73c36a8-b2c5-493f-a02d-dfc0d0830f7b"
  }
}

resource "azurerm_resource_group" "region-1-rg-1" {
  name     = "region-1-rg-1"
  location = "westus"
}

resource "azurerm_virtual_hub" "region-1-vhub-1" {
  virtual_wan_id      = azurerm_virtual_wan.vwan1.id
  resource_group_name = azurerm_resource_group.region-1-rg-1.name
  name                = "vWAN-hub-01"
  location            = "westus"
  address_prefix      = var.vwan-region1-hub1-prefix1

  tags = {
    env      = "Development"
    archUUID = "e73c36a8-b2c5-493f-a02d-dfc0d0830f7b"
  }
}

resource "azurerm_virtual_hub_connection" "region1-connection1" {
  virtual_hub_id            = azurerm_virtual_hub.region-2-vhub-1.id
  remote_virtual_network_id = azurerm_virtual_network.region-1-vnet-1.id
  name                      = "conn-vnet1-to-vwan-hub"
}

resource "azurerm_virtual_network" "region-1-vnet-1" {
  resource_group_name = azurerm_resource_group.region-2-rg-1.name
  name                = "vnet-1"
  location            = "West US"

  address_space = [
    var.region-1-vnet-1-cidr,
  ]

  tags = {
    env      = "Development"
    archUUID = "e73c36a8-b2c5-493f-a02d-dfc0d0830f7b"
  }
}

resource "azurerm_firewall" "fw01" {
  sku_tier            = "Premium"
  sku_name            = "AZFW_Hub"
  resource_group_name = azurerm_resource_group.region-1-rg-1.name
  name                = "fw01"
  location            = "East US"

  tags = {
    env      = "Development"
    archUUID = "e73c36a8-b2c5-493f-a02d-dfc0d0830f7b"
  }

  virtual_hub {
    virtual_hub_id  = azurerm_virtual_hub.region-1-vhub-1.id
    public_ip_count = 1
  }
}

resource "azurerm_firewall_policy" "fw-pol01" {
  resource_group_name = azurerm_resource_group.region-1-rg-1.name
  name                = "fw-pol01"
  location            = "East US"
}

resource "azurerm_firewall_policy_rule_collection_group" "region1-policy1" {
  priority           = 100
  name               = "fw-pol01-rules"
  firewall_policy_id = azurerm_firewall_policy.fw-pol01.id

  network_rule_collection {
    priority = 100
    name     = "network_rules1"
    action   = "Allow"
    rule {
      name = "network_rule_collection1_rule1"
      destination_addresses = [
        "*",
      ]
      destination_ports = [
        "*",
      ]
      protocols = [
        "TCP",
        "UDP",
        "ICMP",
      ]
      source_addresses = [
        "*",
      ]
    }
  }
}

resource "azurerm_vpn_gateway" "region1-gateway1" {
  virtual_hub_id      = azurerm_virtual_hub.region-1-vhub-1.id
  resource_group_name = azurerm_resource_group.region-1-rg-1.name
  name                = "vpngw-01"
  location            = "East US"
}

resource "azurerm_vpn_site" "region1-officesite1" {
  virtual_wan_id      = azurerm_virtual_wan.vwan1.id
  resource_group_name = azurerm_resource_group.region-1-rg-1.name
  name                = "officesite-01"
  location            = "East US"

  address_cidrs = [
    "10.100.0.0/24",
  ]

  link {
    speed_in_mbps = 20
    name          = "Office-Link-1"
    ip_address    = "10.1.0.0"
  }

  tags = {
    env      = "Development"
    archUUID = "e73c36a8-b2c5-493f-a02d-dfc0d0830f7b"
  }
}

resource "azurerm_vpn_gateway_connection" "region1-officesite1" {
  vpn_gateway_id     = azurerm_vpn_gateway.region1-gateway1.id
  remote_vpn_site_id = azurerm_vpn_site.region1-officesite1.id
  name               = "officesite1-conn"

  vpn_link {
    vpn_site_link_id = azurerm_vpn_site.region1-officesite1.link[0].id
    name             = "link1"
  }
}

resource "azurerm_point_to_site_vpn_gateway" "region1-p2s-01" {
  vpn_server_configuration_id = azurerm_vpn_server_configuration.region1-p2s-conn-01.id
  virtual_hub_id              = azurerm_virtual_hub.region-1-vhub-1.id
  scale_unit                  = 1
  resource_group_name         = azurerm_resource_group.region-1-rg-1.name
  name                        = "p2s-01"
  location                    = "East US"

  connection_configuration {
    name = "p2s-01"
    vpn_client_address_pool {
      address_prefixes = [
        "10.10.12.0/24",
      ]
    }
  }

  tags = {
    env      = "Development"
    archUUID = "e73c36a8-b2c5-493f-a02d-dfc0d0830f7b"
  }
}

resource "azurerm_vpn_server_configuration" "region1-p2s-conn-01" {
  resource_group_name = azurerm_resource_group.region-1-rg-1.name
  name                = "p2s-conn-01"
  location            = "East US"

  azure_active_directory_authentication {
    tenant   = "GUID-goes-here"
    issuer   = "https://sts.windows.net/your-Directory-ID/"
    audience = "GUID-goes-here"
  }

  vpn_authentication_types = [
    "AAD",
  ]
}

resource "azurerm_express_route_gateway" "region1-er-gateway-01" {
  virtual_hub_id      = azurerm_virtual_hub.region-1-vhub-1.id
  scale_units         = 1
  resource_group_name = azurerm_resource_group.region-1-rg-1.name
  name                = "er-gateway-01"
  location            = "East US"
}

