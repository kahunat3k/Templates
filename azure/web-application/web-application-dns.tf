# Brainboard auto-generated file.

resource "azurerm_dns_zone" "dns-zone" {
  tags                = merge(var.tags)
  resource_group_name = azurerm_resource_group.app-service-resource-group.name
  name                = "app-service.brainboard.co"
}

resource "azurerm_dns_a_record" "dns_a_record" {
  zone_name           = azurerm_dns_zone.dns-zone.name
  ttl                 = 300
  tags                = merge(var.tags)
  resource_group_name = azurerm_resource_group.app-service-resource-group.name
  name                = "app-service-a-record"

  records = [
    "10.0.180.17",
  ]
}

