variable "description" {
  description = "The description of the policy assignment."
  type        = string
  default     = null
}

variable "display_name" {
  description = "The display name of the policy assignment."
  type        = string
  default     = null
}

variable "enforce" {
  description = "Whether to enforce the policy assignment."
  type        = bool
  default     = true
}

variable "location" {
  description = "The location of the policy assignment."
  type        = string
  default     = null
}

variable "management_group_policy_assignments" {
  description = "Map of management group policy assignments."
  type        = any
  default     = {}
}

variable "management_group_id" {
  description = "The ID of the management group."
  type        = string
}

variable "metadata" {
  description = "Metadata for the policy assignment."
  type        = any
  default     = null
}

variable "name" {
  description = "The name of the policy assignment."
  type        = string
}

variable "parameters" {
  description = "Parameters for the policy assignment."
  type        = any
  default     = null
}

variable "policy_definition_id" {
  description = "The ID of the policy definition."
  type        = string
}

variable "not_scopes" {
  description = "A list of resource IDs that are excluded from the policy assignment."
  type        = list(string)
  default     = []
}



variable "identity" {
  description = "The identity block for the policy assignment."
  type = object({
    type         = string
    identity_ids = optional(list(string))
  })
  default = null
}

variable "non_compliance_message" {
  description = "The non-compliance message block."
  type = object({
    content                        = string
    policy_definition_reference_id = string
  })
  default = null
}

variable "content" {
  description = "Content for the non-compliance message."
  type        = string
  default     = null
}

variable "policy_exemptions" {
  description = "Map of policy exemptions."
  type        = any
  default     = {}
}

variable "policy_definition_reference_id" {
  description = "Reference ID for the policy definition."
  type        = string
  default     = null
}

variable "overrides" {
  description = "Overrides block for the policy assignment."
  type        = any
  default     = null
}

variable "value" {
  description = "Value for the override."
  type        = any
  default     = null
}

variable "override_selector" {
  description = "Override selector block."
  type        = any
  default     = null
}

variable "in" {
  description = "List of values for 'in' selector."
  type        = any
  default     = null
}

variable "not_in" {
  description = "List of values for 'not_in' selector."
  type        = any
  default     = null
}

variable "resource_selectors" {
  description = "Resource selectors block."
  type        = any
  default     = null
}

variable "resource_selector" {
  description = "Resource selector block."
  type        = any
  default     = null
}

variable "kind" {
  description = "Kind for the resource selector."
  type        = string
  default     = null
}
