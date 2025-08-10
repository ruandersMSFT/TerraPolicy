variable "display_name" {
  description = "(Required) The Display Name of the Policy Set Definition."
  type        = string
}

variable "file_path" {
  type        = any
  description = "The filepath to the custom policy. Omitting this assumes the policy is located in the module library"
  default     = null
}

variable "management_group_id" {
  description = "(Required) The Management Group ID where the Policy Set Definition will be created."
  type        = string
}

variable "name" {
  description = "(Required) The Name of the Policy Set Defintion."
  type        = string
}

variable "parameters" {
  type        = any
  description = "Parameters for the policy definition. This field is a JSON object representing the parameters of your policy definition. Omitting this assumes the parameters are located in the policy file"
  default     = null
}

variable "policy_definition_references" {
  description = "A list of policy definition references to include in the policy set."
  type        = list(object({
    policy_definition_id = string
    version              = optional(string)
    parameter_values     = optional(any)
  }))
  default     = null
}

variable "policy_type" {
  description = "(Required) The Type of the Policy Set Definition."
  type        = string
  default = "Custom"
}
