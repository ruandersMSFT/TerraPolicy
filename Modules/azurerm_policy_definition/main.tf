resource "azurerm_policy_definition" "this" {
  description         = local.description
  display_name        = var.display_name
  management_group_id = var.management_group_id
  metadata            = jsonencode(local.metadata)
  mode                = var.mode
  name                = var.name
  parameters          = length(local.parameters) > 0 ? jsonencode(local.parameters) : null
  policy_rule         = jsonencode(local.policy_rule)
  policy_type         = var.policy_type
}

module "management_group_policy_assignment" {
  source   = "../azurerm_management_group_policy_assignment"
  for_each = var.management_group_policy_assignments

  description            = each.value.description
  display_name           = each.value.display_name
  enforce                = each.value.enforce
  identity               = each.value.identity
  location               = each.value.location
  management_group_id    = each.value.management_group_id
  metadata               = each.value.metadata
  name                   = each.key
  non_compliance_message = each.value.non_compliance_message
  not_scopes             = each.value.not_scopes
  overrides              = each.value.overrides
  parameters             = each.value.parameters
  policy_definition_id   = azurerm_policy_definition.this.id
  policy_exemptions      = each.value.policy_exemptions
  resource_selectors     = each.value.resource_selectors
}

module "subscription_policy_assignment" {
  source   = "../azurerm_subscription_policy_assignment"
  for_each = var.subscription_policy_assignments

  description            = each.value.description
  display_name           = each.value.display_name
  enforce                = each.value.enforce
  identity               = each.value.identity
  location               = each.value.location
  metadata               = each.value.metadata
  name                   = each.key
  non_compliance_message = each.value.non_compliance_message
  not_scopes             = each.value.not_scopes
  overrides              = each.value.overrides
  parameters             = each.value.parameters
  policy_definition_id   = azurerm_policy_definition.this.id
  policy_exemptions      = each.value.policy_exemptions
  resource_selectors     = each.value.resource_selectors
  subscription_id        = each.value.subscription_id
}

resource "azurerm_resource_group_policy_assignment" "this" {
  for_each = var.resource_group_policy_assignments

  description          = each.value.description
  display_name         = each.value.display_name
  enforce              = each.value.enforce
  name                 = each.key
  location             = each.value.location
  metadata             = each.value.metadata
  policy_definition_id = azurerm_policy_definition.this.id
  resource_group_id    = each.value.resource_group_id
  not_scopes           = each.value.not_scopes
  parameters           = each.value.parameters

  dynamic "identity" {
    for_each = (each.value.identity != null) ? [each.value.identity] : []

    content {
      type         = each.value.identity.type
      identity_ids = each.value.identity.identity_ids
    }
  }

  dynamic "non_compliance_message" {
    for_each = (each.value.non_compliance_message != null) ? [each.value.non_compliance_message] : []

    content {
      content                        = each.value.content
      policy_definition_reference_id = each.value.policy_definition_reference_id
    }
  }

  dynamic "overrides" {
    for_each = (each.value.overrides != null) ? [each.value.overrides] : []

    content {
      value = each.value.value

      dynamic "selectors" {
        for_each = (each.value.override_selector != null) ? [each.value.override_selector] : []

        content {
          in     = each.value.in
          not_in = each.value.not_in
        }
      }
    }
  }

  dynamic "resource_selectors" {
    for_each = (each.value.resource_selectors != null) ? [each.value.resource_selectors] : []

    content {
      name = each.value.name

      dynamic "selectors" {
        for_each = (each.value.resource_selector != null) ? [each.value.resource_selector] : []

        content {
          kind   = each.value.kind
          in     = each.value.in
          not_in = each.value.not_in
        }
      }
    }
  }
}

resource "azurerm_resource_policy_assignment" "this" {
  for_each = var.resource_policy_assignments

  description          = each.value.description
  display_name         = each.value.display_name
  enforce              = each.value.enforce
  name                 = each.key
  location             = each.value.location
  metadata             = each.value.metadata
  policy_definition_id = azurerm_policy_definition.this.id
  resource_id          = each.value.resource_id
  not_scopes           = each.value.not_scopes
  parameters           = each.value.parameters

  dynamic "identity" {
    for_each = (each.value.identity != null) ? [each.value.identity] : []

    content {
      type         = each.value.identity.type
      identity_ids = each.value.identity.identity_ids
    }
  }

  dynamic "non_compliance_message" {
    for_each = (each.value.non_compliance_message != null) ? [each.value.non_compliance_message] : []

    content {
      content                        = each.value.content
      policy_definition_reference_id = each.value.policy_definition_reference_id
    }
  }

  dynamic "overrides" {
    for_each = (each.value.overrides != null) ? [each.value.overrides] : []

    content {
      value = each.value.value

      dynamic "selectors" {
        for_each = (each.value.override_selector != null) ? [each.value.override_selector] : []

        content {
          in     = each.value.in
          not_in = each.value.not_in
        }
      }
    }
  }

  dynamic "resource_selectors" {
    for_each = (each.value.resource_selectors != null) ? [each.value.resource_selectors] : []

    content {
      name = each.value.name

      dynamic "selectors" {
        for_each = (each.value.resource_selector != null) ? [each.value.resource_selector] : []

        content {
          kind   = each.value.kind
          in     = each.value.in
          not_in = each.value.not_in
        }
      }
    }
  }
}

