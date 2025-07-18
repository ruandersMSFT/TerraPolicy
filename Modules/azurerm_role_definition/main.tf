resource "azurerm_role_definition" "this" {
  name        = "my-custom-role"
  scope       = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"
  description = "This is a custom role created via Terraform"

  permissions {
    actions     = ["*"]
    not_actions = []
  }

  assignable_scopes = [
    "/subscriptions/${data.azurerm_client_config.current.subscription_id}", # /subscriptions/00000000-0000-0000-0000-000000000000
  ]
}
