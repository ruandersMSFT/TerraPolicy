variable "copy_paste_enabled" {
  description = "Enable copy-paste functionality for the Azure Bastion Host."
  type        = bool
  default     = true
}

variable "file_copy_enabled" {
  description = "Enable file copy functionality for the Azure Bastion Host."
  type        = bool
  default     = false
}

variable "ip_configuration" {
  description = "Configuration for the IP settings of the Azure Bastion Host."
  type = object({
    name                 = string
    subnet_id            = string
    public_ip_address_id = optional(string, null)
  })
}

variable "ip_connect_enabled" {
  description = "Enable IP connect functionality for the Azure Bastion Host."
  type        = bool
  default     = false
}

variable "kerberos_enabled" {
  description = "Enable Kerberos authentication for the Azure Bastion Host."
  type        = bool
  default     = false
}

variable "location" {
  description = "The location where the Azure Bastion Host will be created."
  type        = string
}

variable "name" {
  description = "The name of the Azure Bastion Host."
  type        = string
}

variable "resource_group_name" {
  description = "The resource group name for the Azure Bastion Host resource."
  type        = string
}

variable "scale_units" {
  description = "The number of scale units for the Azure Bastion Host. Default is 2."
  type        = number
  default     = 2
}

variable "session_recording_enabled" {
  description = "Enable session recording for the Azure Bastion Host."
  type        = bool
  default     = false
}

variable "shareable_link_enabled" {
  description = "Enable shareable link functionality for the Azure Bastion Host."
  type        = bool
  default     = false
}

variable "sku" {
  description = "The SKU of the Azure Bastion Host."
  type        = string
  default     = "Basic"
}

variable "tags" {
  description = "A mapping of tags to assign to the Azure Bastion Host."
  type        = map(string)
  default     = null
}

variable "tunneling_enabled" {
  description = "Enable tunneling functionality for the Azure Bastion Host."
  type        = bool
  default     = false
}

variable "virtual_network_id" {
  description = "The ID of the virtual network to which the Azure Bastion Host will be connected."
  type        = string
  default     = null
}

variable "zones" {
  description = "A list of availability zones for the Azure Bastion Host."
  type        = list(string)
  default     = null
}
