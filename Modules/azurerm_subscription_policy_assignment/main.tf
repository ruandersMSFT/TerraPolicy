resource "azurerm_subscription_policy_assignment" "this" {

  description          = var.description
  display_name         = var.display_name
  enforce              = var.enforce
  name                 = var.name
  location             = var.location
  metadata             = var.metadata
  not_scopes           = var.not_scopes
  parameters           = var.parameters
  policy_definition_id = var.policy_definition_id
  subscription_id      = var.subscription_id

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
      content                        = var.non_compliance_message.content
      policy_definition_reference_id = var.non_compliance_message.policy_definition_reference_id
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

  lifecycle {
    ignore_changes = [
      # temporary until successfully imported and ready to redeploy with a matching configuration
      policy_definition_id
    ]
  }
}

resource "azurerm_resource_group_policy_exemption" "this" {
  for_each = var.resource_group_policy_exemptions

  description                     = each.value.description
  display_name                    = each.value.display_name
  exemption_category              = each.value.exemption_category
  expires_on                      = each.value.expires_on
  metadata                        = each.value.metadata
  name                            = each.value.name
  policy_assignment_id            = azurerm_management_group_policy_assignment.this.id
  policy_definition_reference_ids = each.value.policy_definition_reference_ids
  resource_group_id               = each.value.resource_group_id
}

resource "azurerm_resource_policy_exemption" "this" {
  for_each = var.resource_policy_exemptions

  description                     = each.value.description
  display_name                    = each.value.display_name
  exemption_category              = each.value.exemption_category
  expires_on                      = each.value.expires_on
  metadata                        = each.value.metadata
  name                            = each.value.name
  policy_assignment_id            = azurerm_management_group_policy_assignment.this.id
  policy_definition_reference_ids = each.value.policy_definition_reference_ids
  resource_id                     = each.value.resource_id
}
