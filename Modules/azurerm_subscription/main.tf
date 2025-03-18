resource "azurerm_subscription" "this" {
  alias             = var.alias
  billing_scope_id  = var.billing_scope_id
  subscription_id   = var.subscription_id
  subscription_name = var.subscription_name
  tags              = var.tags
  workload          = var.workload
}
