resource "azurerm_management_group_policy_set_definition" "this" {
  name                = var.name
  policy_type  = var.policy_type
  display_name = var.display_name

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

    dynamic "policy_definition_group" {
    for_each = [for item in coalesce(local.policy_object.properties.policyDefinitionGroups, []) :
      {
        name                 = item.name
        displayName          = try(item.displayName, null)
        description          = try(item.description, null)
        category             = try(item.category, null)
        additionalMetadataId = try(item.additionalMetadataId, null)
      } if item.name != null && item.name != ""
    ]
    content {
      name                            = policy_definition_group.value["name"]
      display_name                    = policy_definition_group.value["displayName"]
      category                        = policy_definition_group.value["category"]
      description                     = policy_definition_group.value["description"]
      additional_metadata_resource_id = policy_definition_group.value["additionalMetadataId"]
    }
  }

  description         = try(local.policy_object.properties.description, "${local.policy_object.properties.displayName} Policy Set Definition at scope ${var.management_group_id}")
  management_group_id = var.management_group_id
  metadata            = try(length(local.policy_object.properties.metadata) > 0, false) ? jsonencode(local.policy_object.properties.metadata) : null
  parameters          = try(length(local.policy_object.properties.parameters) > 0, false) ? jsonencode(local.policy_object.properties.parameters) : null

}
