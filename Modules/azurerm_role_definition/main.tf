resource "azurerm_role_definition" "this" {
  name        = "my-custom-role2"
  scope       = "/providers/Microsoft.Management/managementGroups/cisanetmg"
  description = "This is a custom role created via Terraform"

  permissions {
    actions     = ["*"]
    not_actions = []
  }

  assignable_scopes = [
    "/providers/Microsoft.Management/managementGroups/cisanetmg", # /subscriptions/00000000-0000-0000-0000-000000000000
  ]
}
