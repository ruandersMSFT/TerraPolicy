variable "description" {
  description = "The description of the Azure Policy Definition."
  type        = string
  default     = null
}

variable "category" {
  description = "The category of the policy definition. This is a string value that represents the category of the policy definition. Omitting this will fallback to meta in the definition or var.category"
  type        = string
  default     = null
}

variable "display_name" {
  description = "The ID of the Management Group to assign the Policy Definition to."
  type        = string
}

variable "file_path" {
  type        = any
  description = "The filepath to the custom policy. Omitting this assumes the policy is located in the module library"
  default     = null
}

variable "management_group_id" {
  type        = string
  description = "The management group scope at which the policy will be defined. Defaults to current Subscription if omitted. Changing this forces a new resource to be created."
  default     = null
}

variable "management_group_policy_assignments" {
  description = "A map of management group IDs to their policy assignment details."
  type = map(object({
    description  = optional(string)
    display_name = optional(string)
    enforce      = optional(bool, true)
    identity = optional(object({
      type         = string
      identity_ids = optional(list(string), null)
    }))
    location            = optional(string)
    management_group_id = string
    metadata            = optional(any, null)
    non_compliance_message = optional(object({
      content                        = string
      policy_definition_reference_id = optional(string)
    }))
    not_scopes = optional(list(string))
    parameters = optional(any, null)
    overrides = optional(list(object({
      value = string
      selectors = optional(list(object({
        in     = list(string)
        not_in = list(string)
      })))
    })))
    resource_selectors = optional(list(object({
      name = string
      selectors = optional(list(object({
        kind   = string
        in     = list(string)
        not_in = list(string)
      })))
    })))
  }))
  default = {}
}

variable "metadata" {
  type        = any
  description = "The metadata for the policy definition. This is a JSON object representing additional metadata that should be stored with the policy definition. Omitting this will fallback to meta in the definition or merge var.policy_category and var.policy_version"
  default     = null
}

variable "mode" {
  description = "The ID of the Management Group to assign the Policy Definition to."
  type        = string
}

variable "name" {
  description = "The ID of the Management Group to assign the Policy Definition to."
  type        = string
}

variable "parameters" {
  type        = any
  description = "Parameters for the policy definition. This field is a JSON object representing the parameters of your policy definition. Omitting this assumes the parameters are located in the policy file"
  default     = null
}

variable "rule" {
  type        = any
  description = "The policy rule for the policy definition. This is a JSON object representing the rule that contains an if and a then block. Omitting this assumes the rules are located in the policy file"
  default     = null
}

variable "subscription_policy_assignments" {
  description = "A map of subscription IDs to their policy assignment details."
  type = map(object({
    description  = optional(string)
    display_name = optional(string)
    enforce      = optional(bool, true)
    identity = optional(object({
      type         = string
      identity_ids = optional(list(string), null)
    }))
    location = optional(string)
    metadata = optional(any, null)
    non_compliance_message = optional(object({
      content                        = string
      policy_definition_reference_id = optional(string)
    }))
    not_scopes = optional(list(string))
    parameters = optional(any, null)
    overrides = optional(list(object({
      value = string
      selectors = optional(list(object({
        in     = list(string)
        not_in = list(string)
      })))
    })))
    resource_selectors = optional(list(object({
      name = string
      selectors = optional(list(object({
        kind   = string
        in     = list(string)
        not_in = list(string)
      })))
    })))
    subscription_id = string
  }))
  default = {}
}

variable "policy_type" {
  description = "The ID of the Management Group to assign the Policy Definition to."
  type        = string
}

variable "policy_version" {
  description = "The version of the policy definition. This is a string value that represents the category of the policy definition. Omitting this will fallback to meta in the definition or var.policy_version"
  type        = string
  default     = null
}
