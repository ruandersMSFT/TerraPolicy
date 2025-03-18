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

variable "policy_type" {
  description = "The ID of the Management Group to assign the Policy Definition to."
  type        = string
}

variable "policy_version" {
  description = "The version of the policy definition. This is a string value that represents the category of the policy definition. Omitting this will fallback to meta in the definition or var.policy_version"
  type        = string
  default     = null
}
