# Brainboard auto-generated file.

resource "azurerm_virtual_network" "virtual_network_2_c_c" {
  resource_group_name = azurerm_resource_group.resource-group_5_c_c.name
  name                = "vnet-spoke"
  location            = "East US"

  address_space = [
    local.vnet_spoke_ip,
  ]

  tags = {
    env      = "Development"
    archUUID = "7a693b6e-6769-4d22-ba75-7a1c513835b6"
  }
}

resource "azurerm_virtual_network" "virtual_network_2" {
  resource_group_name = azurerm_resource_group.resource-group_5.name
  name                = "vnet-hub"
  location            = "East US"

  address_space = [
    local.vnet_hub_ip,
  ]

  tags = {
    env      = "Development"
    archUUID = "7a693b6e-6769-4d22-ba75-7a1c513835b6"
  }
}

resource "azurerm_subnet" "subnet_4" {
  virtual_network_name = azurerm_virtual_network.virtual_network_2.name
  resource_group_name  = azurerm_resource_group.resource-group_5.name
  name                 = "snet-firewall"

  address_prefixes = [
    local.firewall_snet,
  ]
}

resource "azurerm_subnet" "subnet_4_c_c_4_c" {
  virtual_network_name = azurerm_virtual_network.virtual_network_2_c_c.name
  resource_group_name  = azurerm_resource_group.resource-group_5_c_c.name
  name                 = "snet-privatelinkendpoints"

  address_prefixes = [
    local.pe_snet,
  ]
}

resource "azurerm_subnet" "subnet_4_c_c_4_c_c_c_1_c_c_c" {
  virtual_network_name = azurerm_virtual_network.virtual_network_2_c_c.name
  resource_group_name  = azurerm_resource_group.resource-group_5_c_c.name
  name                 = "snet-clusternodes"

  address_prefixes = [
    local.cluster_snet,
  ]
}

resource "azurerm_subnet" "subnet_4_c_c" {
  virtual_network_name = azurerm_virtual_network.virtual_network_2.name
  resource_group_name  = azurerm_resource_group.resource-group_5.name
  name                 = "snet-bastion"

  address_prefixes = [
    local.bastion_snet,
  ]
}

resource "azurerm_resource_group" "resource-group_5_c_c" {
  name     = "rg-network-spokes"
  location = "East US"

  tags = {
    env      = "Development"
    archUUID = "7a693b6e-6769-4d22-ba75-7a1c513835b6"
  }
}

resource "azurerm_resource_group" "resource-group_5" {
  name     = "rg-network-hub"
  location = "East US"

  tags = {
    env      = "Development"
    archUUID = "7a693b6e-6769-4d22-ba75-7a1c513835b6"
  }
}

resource "azurerm_kubernetes_cluster" "kubernetes_cluster_6" {
  resource_group_name = azurerm_resource_group.resource-group_5_c_c.name
  name                = "aks_production_cluster"
  location            = "East US"
  dns_prefix          = "exampleaks1"

  default_node_pool {
    vm_size    = "Standard_D2_v2"
    node_count = 3
    name       = "default"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    env      = "Development"
    archUUID = "7a693b6e-6769-4d22-ba75-7a1c513835b6"
  }
}

resource "azurerm_key_vault" "key_vault_7" {
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"
  resource_group_name = azurerm_resource_group.resource-group_5_c_c.name
  name                = "kvproductionakssecrects"
  location            = "East US"

  tags = {
    env      = "Development"
    archUUID = "7a693b6e-6769-4d22-ba75-7a1c513835b6"
  }
}

data "azurerm_client_config" "current" {
}

resource "azurerm_private_endpoint" "private_endpoint_9" {
  subnet_id           = azurerm_subnet.subnet_4_c_c_4_c.id
  resource_group_name = azurerm_resource_group.resource-group_5_c_c.name
  name                = "pe-kv-production"
  location            = "East US"

  private_service_connection {
    private_connection_resource_id = azurerm_key_vault.key_vault_7.id
    name                           = "connectiontokv"
    is_manual_connection           = false
    subresource_names = [
      "Vault",
    ]
  }

  tags = {
    env      = "Development"
    archUUID = "7a693b6e-6769-4d22-ba75-7a1c513835b6"
  }
}

resource "azurerm_container_registry" "container_registry_10" {
  sku                 = "Premium"
  resource_group_name = azurerm_resource_group.resource-group_5_c_c.name
  name                = "crproductionimages"
  location            = "East US"

  tags = {
    env      = "Development"
    archUUID = "7a693b6e-6769-4d22-ba75-7a1c513835b6"
  }
}

resource "azurerm_private_endpoint" "private_endpoint_11" {
  subnet_id           = azurerm_subnet.subnet_4_c_c_4_c.id
  resource_group_name = azurerm_resource_group.resource-group_5_c_c.name
  name                = "pe-container-reg"
  location            = "East US"

  private_service_connection {
    private_connection_resource_id = azurerm_container_registry.container_registry_10.id
    name                           = "conn-to-cont-reg"
    is_manual_connection           = false
    subresource_names = [
      "registry",
    ]
  }

  tags = {
    env      = "Development"
    archUUID = "7a693b6e-6769-4d22-ba75-7a1c513835b6"
  }
}

resource "azurerm_firewall" "firewall_13" {
  sku_tier            = "Standard"
  sku_name            = "AZFW_VNet"
  resource_group_name = azurerm_resource_group.resource-group_5.name
  name                = "productionfirewall"
  location            = "East US"

  tags = {
    env      = "Development"
    archUUID = "7a693b6e-6769-4d22-ba75-7a1c513835b6"
  }
}

resource "azurerm_virtual_network_peering" "virtual_network_peering_14" {
  virtual_network_name         = azurerm_virtual_network.virtual_network_2.name
  resource_group_name          = azurerm_resource_group.resource-group_5.name
  remote_virtual_network_id    = azurerm_virtual_network.virtual_network_2_c_c.id
  name                         = "peerhubtospoke"
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

resource "azurerm_bastion_host" "bastion_host_15" {
  resource_group_name = azurerm_resource_group.resource-group_5.name
  name                = "bastion_production"
  location            = "East US"

  tags = {
    env      = "Development"
    archUUID = "7a693b6e-6769-4d22-ba75-7a1c513835b6"
  }
}

