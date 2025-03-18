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

variable "subscription_ids" {
  description = "(Optional) A list of Subscription GUIDs which should be assigned to the Management Group."
  type        = list(string)
  default     = []
}