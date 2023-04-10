# Brainboard auto-generated file.

resource "azurerm_sql_server" "azurerm_sql_server-0e44baf8" {
  version                      = "12.0"
  tags                         = merge(var.tags)
  resource_group_name          = azurerm_resource_group.app-service-resource-group.name
  name                         = var.sql-server-name
  location                     = "France Central"
  administrator_login_password = "AVyP#KtW^#ul)6rwIgh?)>F+Cn50s"
  administrator_login          = var.sql-server-admin-user
}

resource "azurerm_sql_database" "azurerm_sql_database-5124ee2d" {
  tags                = merge(var.tags)
  server_name         = azurerm_sql_server.azurerm_sql_server-0e44baf8.name
  resource_group_name = azurerm_resource_group.app-service-resource-group.name
  name                = var.sql-db-name
  location            = "France Central"
}

