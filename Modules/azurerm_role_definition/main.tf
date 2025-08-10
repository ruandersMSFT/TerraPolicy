resource "azurerm_role_definition" "this" {
  name        = var.name

  assignable_scopes = var.assignable_scopes
  description       = var.description

  dynamic "permissions" {
    for_each = var.permissions
    content {
      actions          = permissions.value.actions
      data_actions     = permissions.value.data_actions
      not_actions      = permissions.value.not_actions
      not_data_actions = permissions.value.not_data_actions
    }
  }

  role_definition_id = var.role_definition_id
  scope              = var.scope
}
