# Brainboard auto-generated file.

resource "azurerm_log_analytics_workspace" "log_analytics_workspace" {
  tags                = merge(var.tags)
  sku                 = "PerGB2018"
  retention_in_days   = 30
  resource_group_name = azurerm_resource_group.default.name
  name                = "acctest-01"
  location            = var.location
}

resource "azurerm_log_analytics_solution" "log_analytics_solution" {
  workspace_resource_id = azurerm_log_analytics_workspace.log_analytics_workspace.id
  workspace_name        = azurerm_log_analytics_workspace.log_analytics_workspace.name
  tags                  = merge(var.tags)
  solution_name         = "SecurityInsights"
  resource_group_name   = azurerm_resource_group.default.name
  location              = var.location

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/SecurityInsights"
  }
}

resource "azurerm_sentinel_alert_rule_ms_security_incident" "sentinel_alert_rule_ms_security_incident" {
  product_filter             = "Microsoft Cloud App Security"
  name                       = "example-ms-security-incident-alert-rule"
  log_analytics_workspace_id = azurerm_log_analytics_solution.log_analytics_solution.workspace_resource_id
  display_name               = "example rule"

  depends_on = [
    azurerm_log_analytics_solution.log_analytics_solution,
  ]

  severity_filter = [
    "High",
  ]
}

