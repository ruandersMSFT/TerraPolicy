resource "azurerm_policy_definition" "this" {
  description         = var.description
  display_name        = var.display_name
  management_group_id = var.management_group_id
  metadata            = jsonencode(local.metadata)
  mode                = var.mode
  name                = var.name
  parameters          = length(local.parameters) > 0 ? jsonencode(local.parameters) : null
  policy_rule         = jsonencode(local.policy_rule)
  policy_type         = var.policy_type
}
