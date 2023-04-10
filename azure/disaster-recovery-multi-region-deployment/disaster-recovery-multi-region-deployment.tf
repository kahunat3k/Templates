# Brainboard auto-generated file.

resource "azurerm_resource_group" "resource-group-main" {
  tags     = merge(var.tags, {})
  name     = "rg-main"
  location = var.location
}

resource "azurerm_dns_zone" "dns_zone" {
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.resource-group-main.name
  name                = "sub-domain.domain.com"
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

resource "azurerm_service_plan" "service_plan_region1" {
  tags                = merge(var.tags, {})
  sku_name            = "P1v2"
  resource_group_name = azurerm_resource_group.resource-group-reg1.name
  os_type             = "Linux"
  name                = "serviceplan-reg1"
  location            = var.region1
}

resource "azurerm_service_plan" "service_plan_region2" {
  tags                = merge(var.tags, {})
  sku_name            = "P1v2"
  resource_group_name = azurerm_resource_group.resource-group-reg2.name
  os_type             = "Linux"
  name                = "serviceplan-reg2"
  location            = var.region2
}

resource "azurerm_linux_function_app" "linux_function_app_reg2" {
  tags                       = merge(var.tags, {})
  storage_account_name       = azurerm_storage_account.storage_account_reg2.name
  storage_account_access_key = azurerm_storage_account.storage_account_reg2.primary_access_key
  service_plan_id            = azurerm_service_plan.service_plan_region2.id
  resource_group_name        = azurerm_resource_group.resource-group-reg2.name
  name                       = "linux-function-app-reg2"
  location                   = var.region2

  depends_on = [
    azurerm_service_plan.service_plan_region2,
  ]

  site_config {
  }
}

resource "azurerm_linux_function_app" "linux_function_app_reg1" {
  tags                       = merge(var.tags, {})
  storage_account_name       = azurerm_storage_account.storage_account_reg1.name
  storage_account_access_key = azurerm_storage_account.storage_account_reg1.primary_access_key
  service_plan_id            = azurerm_service_plan.service_plan_region1.id
  resource_group_name        = azurerm_resource_group.resource-group-reg1.name
  name                       = "linux-function-app-reg1"
  location                   = var.region1

  depends_on = [
    azurerm_service_plan.service_plan_region1,
  ]

  site_config {
  }
}

resource "azurerm_storage_account" "storage_account_reg2" {
  tags                     = merge(var.tags, {})
  resource_group_name      = azurerm_resource_group.resource-group-reg2.name
  name                     = "sareg2${random_integer.ri.result}"
  min_tls_version          = "TLS1_2"
  location                 = var.region2
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

  blob_properties {
    versioning_enabled  = true
    change_feed_enabled = true
  }
}

resource "azurerm_storage_account" "storage_account_reg1" {
  tags                     = merge(var.tags, {})
  resource_group_name      = azurerm_resource_group.resource-group-reg1.name
  name                     = "sareg1${random_integer.ri.result}"
  min_tls_version          = "TLS1_2"
  location                 = var.region1
  account_tier             = "Standard"
  account_replication_type = "LRS"

  blob_properties {
    versioning_enabled  = true
    change_feed_enabled = true
  }
}

resource "azurerm_cosmosdb_account" "cosmosdb_account_c_c" {
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

resource "azurerm_resource_group" "resource-group-reg2" {
  tags     = merge(var.tags, {})
  name     = "rg_reg2"
  location = var.region2
}

resource "azurerm_resource_group" "resource-group-reg1" {
  tags     = merge(var.tags, {})
  name     = "rg_reg1"
  location = var.region1
}

resource "azurerm_virtual_network" "virtual_network_20" {
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.resource-group-reg1.name
  name                = "vnet_region1"
  location            = var.region1

  address_space = [
    "10.10.0.0/16",
  ]
}

resource "azurerm_virtual_network" "virtual_network_21" {
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.resource-group-reg2.name
  name                = "vnet_region2"
  location            = var.region2

  address_space = [
    "10.20.0.0/16",
  ]
}

resource "azurerm_virtual_network_peering" "virtual_network_peering_22" {
  virtual_network_name         = azurerm_virtual_network.virtual_network_20.name
  resource_group_name          = azurerm_resource_group.resource-group-reg1.name
  remote_virtual_network_id    = azurerm_virtual_network.virtual_network_21.id
  name                         = "peer_reg1toreg2"
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

resource "azurerm_linux_virtual_machine" "linux_virtual_machine_reg1" {
  tags                = merge(var.tags, {})
  size                = "Standard_DS2_v2"
  resource_group_name = azurerm_resource_group.resource-group-reg1.name
  name                = "vmreg1"
  location            = var.region1
  admin_username      = "adminuser"

  admin_ssh_key {
    username   = "adminuser"
    public_key = var.public_key
  }

  network_interface_ids = [
    azurerm_network_interface.network_interface_reg1.id,
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

resource "azurerm_virtual_network_peering" "virtual_network_peering_23" {
  virtual_network_name      = azurerm_virtual_network.virtual_network_21.name
  resource_group_name       = azurerm_resource_group.resource-group-reg2.name
  remote_virtual_network_id = azurerm_virtual_network.virtual_network_20.id
  name                      = "peer_reg2toreg1"
}

resource "azurerm_linux_virtual_machine" "linux_virtual_machine_reg2" {
  tags                = merge(var.tags, {})
  size                = "Standard_DS2_v2"
  resource_group_name = azurerm_resource_group.resource-group-reg2.name
  name                = "vmreg2"
  location            = var.region2
  admin_username      = "adminuser"

  admin_ssh_key {
    username   = "adminuser"
    public_key = var.public_key
  }

  network_interface_ids = [
    azurerm_network_interface.network_interface_reg2.id,
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

resource "azurerm_traffic_manager_profile" "traffic_manager_profile_24" {
  traffic_routing_method = "Weighted"
  tags                   = merge(var.tags, {})
  resource_group_name    = azurerm_resource_group.resource-group-main.name
  name                   = "traffic-manager"

  dns_config {
    ttl           = 100
    relative_name = "dr-traffic-manager-test-brainboard"
  }

  monitor_config {
    tolerated_number_of_failures = 3
    timeout_in_seconds           = 5
    protocol                     = "HTTP"
    port                         = 443
    path                         = "/"
    interval_in_seconds          = 10
    custom_header {
      value = "1"
      name  = "health-check"
    }
  }
}

resource "azurerm_network_interface" "network_interface_reg2" {
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.resource-group-reg2.name
  name                = "nic_rg2"
  location            = var.region2

  ip_configuration {
    subnet_id                     = azurerm_subnet.subnet_reg2.id
    private_ip_address_allocation = "Dynamic"
    name                          = "internal"
  }
}

resource "azurerm_network_interface" "network_interface_reg1" {
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.resource-group-reg1.name
  name                = "nic_rg1"
  location            = var.region1

  ip_configuration {
    subnet_id                     = azurerm_subnet.subnet_29.id
    private_ip_address_allocation = "Dynamic"
    name                          = "internal"
  }
}

resource "azurerm_traffic_manager_azure_endpoint" "traffic_manager_azure_endpoint_25" {
  weight             = 1
  target_resource_id = azurerm_public_ip.public_ip_26.id
  profile_id         = azurerm_traffic_manager_profile.traffic_manager_profile_24.id
  name               = "endpoint"
}

resource "azurerm_public_ip" "public_ip_26" {
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.resource-group-reg1.name
  name                = "publicip1"
  location            = var.region1
  domain_name_label   = "example-public-ip-reg1"
  allocation_method   = "Static"
}

resource "azurerm_public_ip" "public_ip_27" {
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.resource-group-reg2.name
  name                = "publicip1"
  location            = var.region2
  domain_name_label   = "example-public-ip-reg2"
  allocation_method   = "Static"
}

resource "azurerm_traffic_manager_azure_endpoint" "traffic_manager_azure_endpoint_28" {
  weight             = 100
  target_resource_id = azurerm_public_ip.public_ip_27.id
  profile_id         = azurerm_traffic_manager_profile.traffic_manager_profile_24.id
  name               = "endpoint2"
}

resource "azurerm_subnet" "subnet_29" {
  virtual_network_name = azurerm_virtual_network.virtual_network_20.name
  resource_group_name  = azurerm_resource_group.resource-group-reg1.name
  name                 = "snet_vm_reg1"

  address_prefixes = [
    "10.10.1.0/24",
  ]
}

resource "azurerm_subnet" "subnet_reg2" {
  virtual_network_name = azurerm_virtual_network.virtual_network_21.name
  resource_group_name  = azurerm_resource_group.resource-group-reg2.name
  name                 = "snet_vm_reg2"

  address_prefixes = [
    "10.20.1.0/24",
  ]
}

resource "azurerm_storage_container" "storage_container_reg1" {
  storage_account_name = azurerm_storage_account.storage_account_reg1.name
  name                 = "container-regionone"

  depends_on = [
    azurerm_storage_account.storage_account_reg1,
  ]
}

resource "azurerm_storage_container" "storage_container_reg2" {
  storage_account_name = azurerm_storage_account.storage_account_reg2.name
  name                 = "container-regiontwo"

  depends_on = [
    azurerm_storage_account.storage_account_reg2,
  ]
}

resource "azurerm_storage_object_replication" "storage_object_replication" {
  source_storage_account_id      = azurerm_storage_account.storage_account_reg1.id
  destination_storage_account_id = azurerm_storage_account.storage_account_reg2.id

  rules {
    source_container_name      = azurerm_storage_container.storage_container_reg1.name
    destination_container_name = azurerm_storage_container.storage_container_reg2.name
  }
}

