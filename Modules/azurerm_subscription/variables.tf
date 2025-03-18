variable "alias" {
  description = "(Optional) The Alias name for the subscription. Terraform will generate a new GUID if this is not supplied. Changing this forces a new Subscription to be created."
  type        = string
  default     = null
}

variable "billing_scope_id" {
  description = "(Optional) The Azure Billing Scope ID. Can be a Microsoft Customer Account Billing Scope ID, a Microsoft Partner Account Billing Scope ID or an Enrollment Billing Scope ID."
  type        = string
  default     = null
}

variable "subscription_id" {
  description = "(Optional) The ID of the Subscription. Changing this forces a new Subscription to be created."
  type        = string
  default     = null
}

variable "subscription_name" {
  description = "(Required) The Name of the Subscription. This is the Display Name in the portal."
  type        = string
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = null
}

variable "workload" {
  description = "(Optional) The workload type of the Subscription. Possible values are Production (default) and DevTest. Changing this forces a new Subscription to be created."
  type        = string
  default     = null
}