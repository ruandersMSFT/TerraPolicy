resource "azurerm_management_group_policy_set_definition" "this" {
  name                = var.name
  policy_type  = var.policy_type
  display_name = var.display_name
  management_group_id = var.management_group_id

  parameters          = length(local.parameters) > 0 ? jsonencode(local.parameters) : null

  policy_definition_reference {
    version              = "1.0.*"
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/e765b5de-1225-4ba3-bd56-1ac6695af988"
    parameter_values     = <<VALUE
    {
      "listOfAllowedLocations": {"value": "[parameters('allowedLocations')]"}
    }
    VALUE
  }
}
