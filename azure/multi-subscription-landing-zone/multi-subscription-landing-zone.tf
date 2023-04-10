# Brainboard auto-generated file.

resource "azurerm_resource_group" "rg-database" {
  tags     = merge(var.tags, {})
  name     = "rg-database"
  location = var.location_spoke
}

resource "azurerm_resource_group" "rg-application" {
  tags     = merge(var.tags, {})
  name     = "rg-application"
  location = var.location_spoke
}

resource "azurerm_resource_group" "resource-group_hub" {
  tags     = merge(var.tags, {})
  name     = "rg_hub"
  location = var.location_hub

  provider = azurerm.hub
}

resource "azurerm_virtual_network" "vnet-database" {
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.rg-database.name
  name                = "vnet-database"
  location            = var.location_spoke

  address_space = [
    var.vnet_database,
  ]
}

resource "azurerm_virtual_network" "virtual_network_hub" {
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.resource-group_hub.name
  name                = "vnet_hub"
  location            = var.location_hub

  address_space = [
    var.vnet_hub,
  ]

  provider = azurerm.hub
}

resource "azurerm_subnet" "snet_database" {
  virtual_network_name = azurerm_virtual_network.vnet-database.name
  resource_group_name  = azurerm_resource_group.rg-database.name
  name                 = "snet_mi"

  address_prefixes = [
    var.snet_mi,
  ]

  delegation {
    name = "managedinstancedelegation"

    service_delegation {
      name    = "Microsoft.Sql/managedInstances"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action", "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"]
    }
  }
}

resource "azurerm_mssql_managed_instance" "mssql_managed_instance_9" {
  vcores                       = 4
  tags                         = merge(var.tags, {})
  subnet_id                    = azurerm_subnet.snet_database.id
  storage_size_in_gb           = 32
  sku_name                     = "GP_Gen5"
  resource_group_name          = azurerm_resource_group.rg-database.name
  name                         = "managedsqlinstance"
  location                     = var.location_spoke
  license_type                 = "BasePrice"
  administrator_login_password = "Br@inb0ard"
  administrator_login          = "mradministrator"

  depends_on = [
    azurerm_route_table.route_table,
    azurerm_subnet_network_security_group_association.subnet_network_security_group_association_14,
  ]
}

resource "azurerm_subnet" "subnet_firewall" {
  virtual_network_name = azurerm_virtual_network.virtual_network_hub.name
  resource_group_name  = azurerm_resource_group.resource-group_hub.name
  name                 = "AzureFirewallSubnet"

  address_prefixes = [
    var.snet_firewall,
  ]

  provider = azurerm.hub
}

resource "azurerm_virtual_network" "vnet_application" {
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.rg-application.name
  name                = "vnet_application"
  location            = var.location_spoke

  address_space = [
    "10.3.0.0/16",
  ]
}

resource "azurerm_kubernetes_cluster" "aks" {
  tags                              = merge(var.tags, {})
  role_based_access_control_enabled = true
  resource_group_name               = azurerm_resource_group.rg-application.name
  name                              = "aksdemo"
  location                          = var.location_spoke
  dns_prefix                        = "aksdemo"

  api_server_authorized_ip_ranges = [
    "1.2.3.4/32",
  ]

  default_node_pool {
    vnet_subnet_id = azurerm_subnet.subnet_aks.id
    vm_size        = "Standard_D2_v2"
    node_count     = 1
    name           = "default"
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_policy = "calico"
    network_plugin = "azure"
  }
}

resource "azurerm_subnet" "subnet_jumphost" {
  virtual_network_name = azurerm_virtual_network.virtual_network_hub.name
  resource_group_name  = azurerm_resource_group.resource-group_hub.name
  name                 = "JumphostSubnet"

  address_prefixes = [
    var.snet_jumphost,
  ]

  provider = azurerm.hub
}

resource "azurerm_network_security_group" "network_security_group" {
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.rg-database.name
  name                = "mi-security-group"
  location            = var.location_spoke
}

resource "azurerm_subnet" "subnet_vpn" {
  virtual_network_name = azurerm_virtual_network.virtual_network_hub.name
  resource_group_name  = azurerm_resource_group.resource-group_hub.name
  name                 = "GatewaySubnet"

  address_prefixes = [
    var.snet_vpn,
  ]

  provider = azurerm.hub
}

resource "azurerm_network_security_rule" "network_security_rule" {
  source_port_range           = "*"
  source_address_prefix       = "*"
  resource_group_name         = azurerm_resource_group.rg-database.name
  protocol                    = "Tcp"
  priority                    = 106
  network_security_group_name = azurerm_network_security_group.network_security_group.name
  name                        = "allow_management_inbound"
  direction                   = "Inbound"
  destination_address_prefix  = "*"
  access                      = "Allow"

  destination_port_ranges = [
    "9000",
    "9003",
    "1438",
    "1440",
    "1452",
  ]
}

resource "azurerm_subnet_network_security_group_association" "subnet_network_security_group_association_14" {
  subnet_id                 = azurerm_subnet.snet_database.id
  network_security_group_id = azurerm_network_security_group.network_security_group.id
}

resource "azurerm_route_table" "route_table" {
  tags                          = merge(var.tags, {})
  resource_group_name           = azurerm_resource_group.rg-database.name
  name                          = "routetable-mi"
  location                      = var.location_spoke
  disable_bgp_route_propagation = false
}

resource "azurerm_subnet_route_table_association" "subnet_route_table_association_16" {
  subnet_id      = azurerm_subnet.snet_database.id
  route_table_id = azurerm_route_table.route_table.id
}

resource "azurerm_firewall" "firewall" {
  tags                = merge(var.tags, {})
  sku_tier            = "Premium"
  sku_name            = "AZFW_VNet"
  resource_group_name = azurerm_resource_group.resource-group_hub.name
  name                = "productionfirewall"
  location            = var.location_hub
  firewall_policy_id  = azurerm_firewall_policy.firewall_policy.id

  ip_configuration {
    subnet_id            = azurerm_subnet.subnet_firewall.id
    public_ip_address_id = azurerm_public_ip.public_ip_app.id
    name                 = "configuration"
  }

  provider = azurerm.hub
}

resource "azurerm_subnet" "subnet_monitoring" {
  virtual_network_name = azurerm_virtual_network.vnet_application.name
  resource_group_name  = azurerm_resource_group.rg-application.name
  name                 = "snet_monitoring"

  address_prefixes = [
    var.snet_monitoring,
  ]
}

resource "azurerm_public_ip" "public_ip_app" {
  tags                = merge(var.tags, {})
  sku                 = "Standard"
  resource_group_name = azurerm_resource_group.resource-group_hub.name
  name                = "pip_firewall"
  location            = var.location_hub
  ip_version          = "IPv4"
  allocation_method   = "Static"

  provider = azurerm.hub
}

resource "azurerm_log_analytics_workspace" "log_analytics_workspace" {
  tags                = merge(var.tags, {})
  sku                 = "PerGB2018"
  retention_in_days   = 30
  resource_group_name = azurerm_resource_group.rg-application.name
  name                = "acctest-01"
  location            = var.location_spoke
}

resource "azurerm_firewall_policy" "firewall_policy" {
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.resource-group_hub.name
  name                = "firewallpolicy"
  location            = var.location_hub

  provider = azurerm.hub
}

resource "azurerm_storage_account" "storage_account" {
  tags                     = merge(var.tags, {})
  resource_group_name      = azurerm_resource_group.rg-application.name
  name                     = "sa${random_id.id.hex}"
  min_tls_version          = "TLS1_2"
  location                 = var.location_spoke
  account_tier             = "Standard"
  account_replication_type = "GRS"
}

resource "azurerm_firewall_policy_rule_collection_group" "firewall_policy_rule_collection_group" {
  priority           = 100
  name               = "fwpolicy_rcg"
  firewall_policy_id = azurerm_firewall_policy.firewall_policy.id

  application_rule_collection {
    priority = 500
    name     = "app_rule_collection1"
    action   = "Deny"
    rule {
      name = "app_rule_collection1_rule1"
      destination_fqdns = [
        "*.brainboard.co",
      ]
      protocols {
        type = "Http"
        port = 80
      }
      protocols {
        type = "Https"
        port = 443
      }
      source_addresses = [
        "10.0.0.1",
      ]
    }
  }

  network_rule_collection {
    priority = 400
    name     = "network_rule_collection1"
    action   = "Deny"
    rule {
      name = "network_rule_collection1_rule1"
      destination_addresses = [
        "192.168.1.1",
      ]
      destination_ports = [
        "80",
      ]
      protocols = [
        "TCP",
        "UDP",
      ]
      source_addresses = [
        "10.0.0.1",
      ]
    }
  }

  provider = azurerm.hub
}

resource "azurerm_public_ip" "public_ip_vpn" {
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.resource-group_hub.name
  name                = "pip_vpn"
  location            = var.location_hub
  allocation_method   = "Dynamic"

  provider = azurerm.hub
}

resource "azurerm_virtual_network_peering" "virtual_network_peering_spoke" {
  virtual_network_name      = azurerm_virtual_network.vnet_application.name
  resource_group_name       = azurerm_resource_group.rg-application.name
  remote_virtual_network_id = azurerm_virtual_network.vnet-database.id
  name                      = "peer_app_to_db"
}

resource "random_id" "id" {

  byte_length = 8
}

resource "azurerm_virtual_network_gateway" "virtual_network_gateway" {
  type                = "Vpn"
  tags                = merge(var.tags, {})
  sku                 = "Standard"
  resource_group_name = azurerm_resource_group.resource-group_hub.name
  name                = "p2s-vpn"
  location            = var.location_hub

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

  provider = azurerm.hub
}

resource "azurerm_subnet" "subnet_aks" {
  virtual_network_name = azurerm_virtual_network.vnet_application.name
  resource_group_name  = azurerm_resource_group.rg-application.name
  name                 = "snet_aks"

  address_prefixes = [
    var.snet_kubernetes,
  ]
}

resource "azurerm_linux_virtual_machine" "linux_virtual_machine" {
  tags                = merge(var.tags, {})
  size                = "Standard_DS2_v2"
  resource_group_name = azurerm_resource_group.resource-group_hub.name
  name                = "jumpostvm"
  location            = var.location_hub
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

  provider = azurerm.hub
}

resource "azurerm_network_interface" "network_interface" {
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.resource-group_hub.name
  name                = "jumphostnic"
  location            = var.location_hub

  ip_configuration {
    subnet_id                     = azurerm_subnet.subnet_jumphost.id
    private_ip_address_allocation = "Dynamic"
    name                          = "internal"
  }

  provider = azurerm.hub
}

resource "azurerm_dns_zone" "dns_zone" {
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.resource-group_hub.name
  name                = "mydomain.com"

  lifecycle {
  }

  provider = azurerm.hub
}

resource "azurerm_dns_a_record" "dns_a_record" {
  zone_name           = azurerm_dns_zone.dns_zone.name
  ttl                 = 300
  target_resource_id  = azurerm_public_ip.public_ip_app.id
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.resource-group_hub.name
  name                = "dnsrecord"

  depends_on = [
    azurerm_public_ip.public_ip_app,
  ]

  provider = azurerm.hub
}

resource "azurerm_virtual_network_peering" "virtual_network_peering_hub_app" {
  virtual_network_name         = azurerm_virtual_network.virtual_network_hub.name
  resource_group_name          = azurerm_resource_group.resource-group_hub.name
  remote_virtual_network_id    = azurerm_virtual_network.vnet_application.id
  name                         = "peer_hub_app"
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true

  provider = azurerm.hub
}

resource "azurerm_virtual_network_peering" "virtual_network_peering_hub_db" {
  virtual_network_name         = azurerm_virtual_network.virtual_network_hub.name
  resource_group_name          = azurerm_resource_group.resource-group_hub.name
  remote_virtual_network_id    = azurerm_virtual_network.vnet-database.id
  name                         = "peer_hub_db"
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true

  provider = azurerm.hub
}

resource "azurerm_virtual_network_peering" "virtual_network_peering_db_hub" {
  virtual_network_name         = azurerm_virtual_network.vnet-database.name
  resource_group_name          = azurerm_resource_group.rg-database.name
  remote_virtual_network_id    = azurerm_virtual_network.virtual_network_hub.id
  name                         = "peer_db_hub"
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

resource "azurerm_virtual_network_peering" "virtual_network_peering_app_hub" {
  virtual_network_name         = azurerm_virtual_network.vnet_application.name
  resource_group_name          = azurerm_resource_group.rg-application.name
  remote_virtual_network_id    = azurerm_virtual_network.virtual_network_hub.id
  name                         = "peer_app_spoke"
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

