resource "azurerm_management_group_policy_set_definition" "this" {
  name                = var.name
  policy_type  = var.policy_type
  display_name = var.display_name
  management_group_id = var.management_group_id

  parameters          = length(local.parameters) > 0 ? jsonencode(local.parameters) : null


  # Dynamic configuration blocks
  dynamic "policy_definition_reference" {
    for_each = [
      for item in local.policy_object.properties.policyDefinitions :
      {
        policyDefinitionId          = item.policyDefinitionId
        parameters                  = try(jsonencode(item.parameters), null)
        policyDefinitionReferenceId = try(item.policyDefinitionReferenceId, null)
        groupNames                  = try(item.groupNames, null)
      }
    ]
    content {
      policy_definition_id = policy_definition_reference.value["policyDefinitionId"]
      parameter_values     = policy_definition_reference.value["parameters"]
      reference_id         = policy_definition_reference.value["policyDefinitionReferenceId"]
      policy_group_names   = policy_definition_reference.value["groupNames"]
    }
  }
}
