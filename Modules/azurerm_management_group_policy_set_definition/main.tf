resource "azurerm_management_group_policy_set_definition" "this" {
  name                = var.name
  policy_type  = var.policy_type
  display_name = var.display_name
  management_group_id = var.management_group_id

  parameters          = length(local.parameters) > 0 ? jsonencode(local.parameters) : null

  dynamic "policy_definition_reference" {
    for_each = local.policy_definition_references
    content {
      policy_definition_id = policy_definition_reference.value.policy_definition_id
      version              = lookup(policy_definition_reference.value, "version", null)
      parameter_values     = lookup(policy_definition_reference.value, "parameter_values", null)
    }
  }
}
