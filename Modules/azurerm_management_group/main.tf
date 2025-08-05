resource "azurerm_management_group" "this" {
  display_name               = var.display_name
  name                       = var.name
  parent_management_group_id = var.parent_management_group_id
  subscription_ids           = var.subscription_ids
}

module "policy_definitions" {
  source = "../azurerm_policy_definition"
  for_each = var.policy_definitions

  name         = each.value.name
  display_name = each.value.display_name
  file_path    = each.value.file_path
  management_group_id = azurerm_management_group.this.id
  mode = each.value.mode
  policy_type = each.value.policy_type
}

module "policy_set_definitions" {
  source = "../azurerm_management_group_policy_set_definition"
  for_each = var.policy_set_definitions

  name         = each.value.name
  display_name = each.value.display_name
  file_path    = each.value.file_path
  management_group_id = azurerm_management_group.this.id
  policy_definition_references = each.value.policy_definition_references

  depends_on = [ module.policy_definitions ]
}
