variable "name" {
  description = "The name of the Azure Private DNS Zone."
  type        = string
}

variable "resource_group_name" {
  description = "The resource group name for the Azure Private DNS Zone resource."
  type        = string
}

variable "soa_records" {
  description = "A SOA record to create in the Private DNS Zone."
  type        = object({
    email        = string
    ttl         = number
    refresh_time = number
    retry_time = number
  })
  default     = null
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = null
}
