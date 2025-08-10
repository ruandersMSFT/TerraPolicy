resource "azurerm_private_dns_zone" "this" {
  name                = var.name
  resource_group_name = azurerm_resource_group.example.name
}
