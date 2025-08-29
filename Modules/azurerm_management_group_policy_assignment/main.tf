resource "azurerm_management_group_policy_assignment" "this" {

  description          = var.description
  display_name         = var.display_name
  enforce              = var.enforce
  name                 = var.name
  location             = var.location
  metadata             = var.metadata
  policy_definition_id = var.policy_definition_id
  management_group_id  = var.management_group_id
  not_scopes           = var.not_scopes
  parameters           = var.parameters

  dynamic "identity" {
    for_each = (var.identity != null) ? [var.identity] : []

    content {
      type         = var.identity.type
      identity_ids = var.identity.identity_ids
    }
  }

  dynamic "non_compliance_message" {
    for_each = (var.non_compliance_message != null) ? [var.non_compliance_message] : []

    content {
      content                        = var.content
      policy_definition_reference_id = var.policy_definition_reference_id
    }
  }

  dynamic "overrides" {
    for_each = (var.overrides != null) ? [var.overrides] : []

    content {
      value = var.value

      dynamic "selectors" {
        for_each = (var.override_selector != null) ? [var.override_selector] : []

        content {
          in     = var.in
          not_in = var.not_in
        }
      }
    }
  }

  dynamic "resource_selectors" {
    for_each = (var.resource_selectors != null) ? [var.resource_selectors] : []

    content {
      name = var.name

      dynamic "selectors" {
        for_each = (var.resource_selector != null) ? [var.resource_selector] : []

        content {
          kind   = var.kind
          in     = var.in
          not_in = var.not_in
        }
      }
    }
  }
}

resource "azurerm_management_group_policy_exemption" "this" {
  for_each = var.policy_exemptions

  description                     = each.value.description
  display_name                    = each.value.display_name
  exemption_category              = each.value.exemption_category
  expires_on                      = each.value.expires_on
  management_group_id             = each.value.management_group_id
  metadata                        = each.value.metadata
  name                            = each.key
  policy_assignment_id            = azurerm_management_group_policy_assignment.this.id
  policy_definition_reference_ids = each.value.policy_definition_reference_ids
}
