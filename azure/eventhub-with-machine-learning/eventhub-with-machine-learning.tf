# Brainboard auto-generated file.

resource "azurerm_resource_group" "resource-group-eventhub" {
  tags     = merge(var.tags, {})
  name     = "rg-eventhub"
  location = var.location
}

resource "azurerm_eventhub" "eventhub" {
  resource_group_name = azurerm_resource_group.resource-group-eventhub.name
  partition_count     = 2
  namespace_name      = azurerm_eventhub_namespace.eventhub_namespace.name
  name                = "acceptanceTestEventHub"
  message_retention   = 1
}

resource "azurerm_eventhub_namespace" "eventhub_namespace" {
  tags                = merge(var.tags, {})
  sku                 = "Standard"
  resource_group_name = azurerm_resource_group.resource-group-eventhub.name
  name                = "example-namespace"
  location            = var.location
  capacity            = 2
}

resource "azurerm_data_factory" "data_factory" {
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.resource-group-eventhub.name
  name                = "dfexample"
  location            = var.location

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_storage_account" "storage_account_iothub" {
  tags                     = merge(var.tags, {})
  resource_group_name      = azurerm_resource_group.resource-group-eventhub.name
  name                     = "iothubstorageacc"
  location                 = var.location
  is_hns_enabled           = true
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
}

resource "azurerm_storage_data_lake_gen2_path" "storage_data_lake_gen2_path" {
  storage_account_id = azurerm_storage_account.storage_account_iothub.id
  resource           = "directory"
  path               = "storage-datalake-path"
  filesystem_name    = azurerm_storage_data_lake_gen2_filesystem.storage_data_lake_gen2_filesystem_iothub.name
}

resource "azurerm_storage_data_lake_gen2_filesystem" "storage_data_lake_gen2_filesystem_iothub" {
  storage_account_id = azurerm_storage_account.storage_account_iothub.id
  name               = "storage-datalake-iothub"

  properties = {
    hello = "aGVsbG8="
  }
}

resource "azurerm_iothub" "iothub" {
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.resource-group-eventhub.name
  name                = "Example-IoTHub"
  location            = var.location

  cloud_to_device {
    max_delivery_count = 30
    default_ttl        = "PT1H"
    feedback {
      time_to_live       = "PT1H10M"
      max_delivery_count = 15
      lock_duration      = "PT30S"
    }
  }

  endpoint {
    max_chunk_size_in_bytes    = 10485760
    file_name_format           = "{iothub}/{partition}_{YYYY}_{MM}_{DD}_{HH}_{mm}"
    encoding                   = "Avro"
    container_name             = azurerm_storage_container.storage_container.name
    connection_string          = azurerm_storage_account.storage_account_iothub.primary_blob_connection_string
    batch_frequency_in_seconds = 60
    authentication_type        = "AzureIotHub.StorageContainer"
  }
  endpoint {
    name                = "export2"
    connection_string   = azurerm_eventhub_authorization_rule.eventhub_authorization_rule.primary_connection_string
    authentication_type = "AzureIotHub.EventHub"
  }

  enrichment {
    value = "$twin.tags.Tenant"
    key   = "tenant"
    endpoint_names = [
      "export",
      "export2",
    ]
  }

  route {
    source    = "DeviceMessages"
    name      = "export"
    enabled   = true
    condition = "true"
    endpoint_names = [
      "export",
    ]
  }
  route {
    source    = "DeviceMessages"
    name      = "export2"
    enabled   = true
    condition = "true"
    endpoint_names = [
      "export2",
    ]
  }

  sku {
    name     = "S1"
    capacity = 1
  }



}

resource "azurerm_eventhub_authorization_rule" "eventhub_authorization_rule" {
  send                = true
  resource_group_name = azurerm_resource_group.resource-group-eventhub.name
  namespace_name      = azurerm_eventhub_namespace.eventhub_namespace.name
  name                = "acctest"
  eventhub_name       = azurerm_eventhub.eventhub.name
}

resource "azurerm_storage_container" "storage_container" {
  storage_account_name  = azurerm_storage_account.storage_account_iothub.id
  name                  = "examplecontainer"
  container_access_type = "private"
}

resource "azurerm_kusto_cluster" "kusto_cluster" {
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.resource-group-eventhub.name
  name                = "kustocluster"
  location            = var.location

  sku {
    name     = "Standard_D13_v2"
    capacity = 2
  }
}

resource "azurerm_kusto_database" "kusto_database" {
  soft_delete_period  = "P31D"
  resource_group_name = azurerm_resource_group.resource-group-eventhub.name
  name                = "my-kusto-database"
  location            = var.location
  hot_cache_period    = "P7D"
  cluster_name        = azurerm_kusto_cluster.kusto_cluster.name
}

resource "azurerm_kusto_eventhub_data_connection" "kusto_eventhub_data_connection" {
  resource_group_name = azurerm_resource_group.resource-group-eventhub.name
  name                = "my-kusto-eventhub-data-connection"
  location            = var.location
  eventhub_id         = azurerm_eventhub.eventhub.id
  database_name       = azurerm_kusto_database.kusto_database.name
  consumer_group      = azurerm_eventhub_consumer_group.eventhub_consumer_group.name
  cluster_name        = azurerm_kusto_cluster.kusto_cluster.name
}

resource "azurerm_eventhub_consumer_group" "eventhub_consumer_group" {
  resource_group_name = azurerm_resource_group.resource-group-eventhub.name
  namespace_name      = azurerm_eventhub_namespace.eventhub_namespace.name
  name                = "acceptanceTestEventHubConsumerGroup"
  eventhub_name       = azurerm_eventhub.eventhub.name
}

resource "azurerm_data_factory_linked_service_kusto" "data_factory_linked_service_kusto" {
  use_managed_identity = true
  name                 = "kusto-linkservice"
  kusto_endpoint       = azurerm_kusto_cluster.kusto_cluster.uri
  kusto_database_name  = azurerm_kusto_database.kusto_database.name
  data_factory_id      = azurerm_data_factory.data_factory.id
}

resource "azurerm_kusto_database_principal_assignment" "kusto_database_principal_assignment" {
  tenant_id           = azurerm_data_factory.data_factory.identity.0.tenant_id
  role                = "Viewer"
  resource_group_name = azurerm_resource_group.resource-group-eventhub.name
  principal_type      = "App"
  principal_id        = azurerm_data_factory.data_factory.identity.0.principal_id
  name                = "KustoPrincipalAssignment"
  database_name       = azurerm_kusto_database.kusto_database.name
  cluster_name        = azurerm_kusto_cluster.kusto_cluster.name
}

resource "azurerm_machine_learning_synapse_spark" "machine_learning_synapse_spark" {
  tags                          = merge(var.tags, {})
  synapse_spark_pool_id         = azurerm_synapse_spark_pool.synapse_spark_pool.id
  name                          = "ml-synapsespark"
  machine_learning_workspace_id = azurerm_machine_learning_workspace.machine_learning_workspace.id
  location                      = var.location

  identity {
    type = "SystemAssigned"
  }
}

data "azurerm_client_config" "current_c_c" {
}

resource "azurerm_application_insights" "application_insights" {
  tags                = merge(var.tags, {})
  resource_group_name = azurerm_resource_group.resource-group-ml.name
  name                = "example-ai"
  location            = var.location
  application_type    = "web"
}

resource "azurerm_key_vault" "key_vault" {
  tenant_id                = data.azurerm_client_config.current_c_c.tenant_id
  tags                     = merge(var.tags, {})
  sku_name                 = "standard"
  resource_group_name      = azurerm_resource_group.resource-group-ml.name
  purge_protection_enabled = true
  name                     = "example-kv"
  location                 = var.location
}

resource "azurerm_storage_account" "storage_account_ml" {
  tags                     = merge(var.tags, {})
  resource_group_name      = azurerm_resource_group.resource-group-ml.name
  name                     = "storageaccountml"
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_resource_group" "resource-group-ml" {
  tags     = merge(var.tags, {})
  name     = "rg-machinelearning"
  location = var.location
}

resource "azurerm_machine_learning_workspace" "machine_learning_workspace" {
  tags                    = merge(var.tags, {})
  storage_account_id      = azurerm_storage_account.storage_account_ml.id
  resource_group_name     = azurerm_resource_group.resource-group-ml.name
  name                    = "example-workspace"
  location                = var.location
  key_vault_id            = azurerm_key_vault.key_vault.id
  application_insights_id = azurerm_application_insights.application_insights.app_id

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_storage_data_lake_gen2_filesystem" "storage_data_lake_gen2_filesystem" {
  storage_account_id = azurerm_storage_account.storage_account_ml.id
  name               = "storage-datalake-ml"

  properties = {
    hello = "aGVsbG8="
  }
}

resource "azurerm_synapse_workspace" "synapse_workspace" {
  tags                                 = merge(var.tags, {})
  storage_data_lake_gen2_filesystem_id = azurerm_storage_data_lake_gen2_filesystem.storage_data_lake_gen2_filesystem.id
  sql_administrator_login_password     = var.synapse_admin_pass
  sql_administrator_login              = "sqladminuser"
  resource_group_name                  = azurerm_resource_group.resource-group-ml.name
  name                                 = "example-synapseworkspace"
  location                             = var.location

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_synapse_spark_pool" "synapse_spark_pool" {
  tags                 = merge(var.tags, {})
  synapse_workspace_id = azurerm_synapse_workspace.synapse_workspace.id
  node_size_family     = "MemoryOptimized"
  node_size            = "Small"
  node_count           = 3
  name                 = "synapsepool"
}

