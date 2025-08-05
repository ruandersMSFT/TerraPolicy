locals {
  # import the custom policy object from a library or specified file path
  policy_object = jsondecode(coalesce(try(
    file(var.file_path),
    "{}" # return empty object if no policy is found
  )))

  parameters  = coalesce(var.parameters, try((local.policy_object).properties.parameters, {}))
}