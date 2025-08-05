variable "display_name" {
  description = "(Optional) A friendly name for this Management Group. If not specified, this will be the same as the name."
  type        = string
  default     = null
}

variable "name" {
  description = "(Optional) The name or UUID for this Management Group, which needs to be unique across your tenant. A new UUID will be generated if not provided. Changing this forces a new resource to be created."
  type        = string
  default     = null
}

variable "parent_management_group_id" {
  description = "(Optional) The ID of the Parent Management Group."
  type        = string
  default     = null
}

variable "policy_definitions" {
  description = "A map of policy definitions to be assigned to the management group."
  type        = map(object({
    name         = string
    display_name = string
    file_path    = string
    mode         = string
    policy_type  = string
  }))
  default     = {}
}

variable "policy_set_definitions" {
  description = "A map of policy set definitions to assign to the management group."
  type        = map(object({
    name         = string
    display_name = string
    file_path    = string
    policy_definition_references = optional(list(object({
      policy_definition_id = string
      version              = optional(string)
      parameter_values     = optional(any)
    })), null)
  }))
  default     = null
}

variable "subscription_ids" {
  description = "(Optional) A list of Subscription GUIDs which should be assigned to the Management Group."
  type        = list(string)
  default     = []
}