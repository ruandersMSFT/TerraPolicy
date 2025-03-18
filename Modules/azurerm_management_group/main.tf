resource "azurerm_management_group" "this" {
  display_name               = var.display_name
  name                       = var.name
  parent_management_group_id = var.parent_management_group_id
  subscription_ids           = var.subscription_ids
}
