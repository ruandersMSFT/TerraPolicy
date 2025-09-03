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

module "resource_group_policy_assignment" {
  source   = "../azurerm_resource_group_policy_assignment"
  for_each = var.resource_group_policy_assignments

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
  resource_group_id      = each.value.resource_group_id
  resource_selectors     = each.value.resource_selectors
}

module "resource_policy_assignment" {
  source   = "../azurerm_resource_policy_assignment"
  for_each = var.resource_policy_assignments

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
  resource_id            = each.value.resource_id
  resource_selectors     = each.value.resource_selectors
}
