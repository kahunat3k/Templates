# Brainboard auto-generated file.

resource "azurerm_postgresql_flexible_server_database" "default" {
  server_id = azurerm_postgresql_flexible_server.default.id
  name      = "${var.name_prefix}-db"
  collation = "en_US.UTF8"
  charset   = "UTF8"
}

