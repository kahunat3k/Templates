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
    var.vnet_hub_addrspace,
  ]
}

resource "azurerm_virtual_network" "virtual_network_spoke" {
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.resource-group_spoke.name
  name                = "vnet_spoke"
  location            = var.location

  address_space = [
    var.vnet_spoke_addrspace,
  ]
}

resource "azurerm_subnet" "subnet_dns_outbound" {
  virtual_network_name = azurerm_virtual_network.virtual_network_hub.name
  resource_group_name  = azurerm_resource_group.resource-group_hub.name
  name                 = "outbounddns"

  address_prefixes = [
    var.snet_dns_outbound_prefix,
  ]

  delegation {
    name = "Microsoft.Network.dnsResolvers"
    service_delegation {
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
      name    = "Microsoft.Network/dnsResolvers"
    }
  }
}

resource "azurerm_subnet" "subnet_dns_inbound" {
  virtual_network_name = azurerm_virtual_network.virtual_network_hub.name
  resource_group_name  = azurerm_resource_group.resource-group_hub.name
  name                 = "snet_dns_inbound"

  address_prefixes = [
    var.snet_dns_inbound_prefix,
  ]

  delegation {
    name = "Microsoft.Network.dnsResolvers"
    service_delegation {
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
      name    = "Microsoft.Network/dnsResolvers"
    }
  }
}

resource "azurerm_subnet" "subnet_hub_default" {
  virtual_network_name = azurerm_virtual_network.virtual_network_hub.name
  resource_group_name  = azurerm_resource_group.resource-group_hub.name
  name                 = "snet_hub_default"

  address_prefixes = [
    var.snet_default_hub_prefix,
  ]
}

resource "azurerm_subnet" "subnet_firewall" {
  virtual_network_name = azurerm_virtual_network.virtual_network_hub.name
  resource_group_name  = azurerm_resource_group.resource-group_hub.name
  name                 = "snet_firewall"

  address_prefixes = [
    var.snet_firewall_prefix,
  ]
}

resource "azurerm_subnet" "subnet_spoke_default" {
  virtual_network_name = azurerm_virtual_network.virtual_network_spoke.name
  resource_group_name  = azurerm_resource_group.resource-group_spoke.name
  name                 = "snet_spoke_default"

  address_prefixes = [
    var.snet_default_spoke_prefix,
  ]
}

resource "azurerm_private_dns_resolver" "dns_resolver" {

  name                = "example"
  resource_group_name = azurerm_resource_group.resource-group_hub.name
  location            = var.location
  virtual_network_id  = azurerm_virtual_network.virtual_network_hub.id
}

resource "azurerm_private_dns_resolver_outbound_endpoint" "example-endpoint" {

  name                    = "example-endpoint"
  private_dns_resolver_id = azurerm_private_dns_resolver.dns_resolver.id
  location                = var.location
  subnet_id               = azurerm_subnet.subnet_dns_inbound.id
}

resource "azurerm_firewall" "firewall_14" {
  tags                = merge(var.tags, {})
  sku_tier            = "Premium"
  sku_name            = "AZFW_VNet"
  resource_group_name = azurerm_resource_group.resource-group_hub.name
  name                = "firewall_demo"
  location            = var.location
  firewall_policy_id  = azurerm_firewall_policy.firewall_policy.id
}

resource "azurerm_firewall_policy" "firewall_policy" {
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.resource-group_hub.name
  name                = "demopolicy"
  location            = var.location
}

resource "azurerm_private_dns_resolver_dns_forwarding_ruleset" "custom_16" {

  name                                       = "example-ruleset"
  resource_group_name                        = azurerm_resource_group.resource-group_hub.name
  location                                   = var.location
  private_dns_resolver_outbound_endpoint_ids = [azurerm_private_dns_resolver_outbound_endpoint.example-endpoint.id]
}

resource "azurerm_private_dns_resolver_forwarding_rule" "custom_17" {

  name                      = "example-rule"
  dns_forwarding_ruleset_id = azurerm_private_dns_resolver_dns_forwarding_ruleset.custom_16.id
  domain_name               = "onprem.local."
  enabled                   = true
  target_dns_servers {
    ip_address = "10.10.0.1"
    port       = 53
  }
  metadata = {
    key = "value"
  }
}

resource "azurerm_private_dns_resolver_inbound_endpoint" "custom_18" {

  name                    = "example-drie"
  private_dns_resolver_id = azurerm_private_dns_resolver.custom_19.id
  location                = var.location
  ip_configurations {
    private_ip_allocation_method = "Dynamic"
    subnet_id                    = azurerm_subnet.subnet_dns_inbound.id
  }
}

resource "azurerm_private_dns_resolver" "custom_19" {

  name                = "example"
  resource_group_name = azurerm_resource_group.resource-group_hub.name
  location            = var.location
  virtual_network_id  = azurerm_virtual_network.virtual_network_hub.id
}

resource "azurerm_virtual_machine" "virtual_machine_20" {
  vm_size             = "Standard_DS1_v2"
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.resource-group_spoke.name
  name                = "${var.prefix}-vm-spoke"
  location            = var.location

  network_interface_ids = [
    azurerm_network_interface.network_interface_vmspoke.id,
  ]

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
}

resource "azurerm_postgresql_server" "postgresql_server_21" {
  version                      = "9.5"
  tags                         = merge(var.tags, {})
  storage_mb                   = 5120
  ssl_enforcement_enabled      = true
  sku_name                     = "B_Gen5_2"
  resource_group_name          = azurerm_resource_group.resource-group_spoke.name
  name                         = "postgresql-server-1"
  location                     = var.location
  geo_redundant_backup_enabled = false
  backup_retention_days        = 7
  auto_grow_enabled            = true
  administrator_login_password = "Br@inb0ard"
  administrator_login          = "psqladmin"
}

resource "azurerm_private_endpoint" "private_endpoint" {
  tags                = merge(var.tags, {})
  subnet_id           = azurerm_subnet.subnet_spoke_default.id
  resource_group_name = azurerm_resource_group.resource-group_spoke.name
  name                = "${var.prefix}-pe"
  location            = var.location

  private_service_connection {
    private_connection_resource_id = azurerm_postgresql_server.postgresql_server_21.id
    name                           = "privateserviceconnection"
    is_manual_connection           = false
  }
}

resource "azurerm_virtual_network_peering" "virtual_network_peering_23" {
  virtual_network_name      = azurerm_virtual_network.virtual_network_spoke.name
  resource_group_name       = azurerm_resource_group.resource-group_hub.name
  remote_virtual_network_id = azurerm_virtual_network.virtual_network_spoke.id
  name                      = "hubtospoke"
}

resource "azurerm_virtual_machine" "virtual_machine_24" {
  vm_size             = "Standard_DS1_v2"
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.resource-group_hub.name
  name                = "${var.prefix}-vm-hub"
  location            = var.location

  network_interface_ids = [
    azurerm_network_interface.network_interface.id,
  ]

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
}

resource "azurerm_network_interface" "network_interface" {
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.resource-group_hub.name
  name                = "${var.prefix}-nic"
  location            = var.location

  ip_configuration {
    subnet_id                     = azurerm_subnet.subnet_hub_default.id
    private_ip_address_allocation = "Dynamic"
    name                          = "internal"
  }
}

resource "azurerm_network_interface" "network_interface_vmspoke" {
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.resource-group_spoke.name
  name                = "nic-vmspoke"
  location            = var.location

  ip_configuration {
    subnet_id                     = azurerm_subnet.subnet_spoke_default.id
    private_ip_address_allocation = "Dynamic"
    name                          = "internal"
  }
}

