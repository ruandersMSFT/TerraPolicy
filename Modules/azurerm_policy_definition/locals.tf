locals {
  # import the custom policy object from a library or specified file path
  policy_object = jsondecode(coalesce(try(
    file(var.file_path),
    "{}" # return empty object if no policy is found
  )))

  description = var.description != null ? var.description : try((local.policy_object).properties.description, null)
  category    = coalesce(var.category, try((local.policy_object).properties.metadata.category, "General"))
  version     = coalesce(var.policy_version, try((local.policy_object).properties.metadata.version, "1.0.0"))
  metadata    = coalesce(null, var.metadata, try((local.policy_object).properties.metadata, merge({ category = local.category }, { version = local.version })))
  parameters  = coalesce(null, var.parameters, try((local.policy_object).properties.parameters, {}))
  policy_rule = coalesce(var.rule, try((local.policy_object).properties.policyRule, null))
}