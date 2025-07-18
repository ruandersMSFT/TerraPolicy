resource "azurerm_role_definition" "this" {
  name        = var.name
  scope       = var.scope
  description = var.description

  dynamic "permissions" {
    for_each = var.permissions
    content {
      actions     = permissions.value.actions
      not_actions = permissions.value.not_actions
    }
  }

  assignable_scopes = var.assignable_scopes
}
