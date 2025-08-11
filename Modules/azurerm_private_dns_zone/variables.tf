variable "a_records" {
  description = "A map of DNS A records to create in the Private DNS Zone. Each key represents the record name."
  type = map(object({
    ttl     = number
    records = list(string)
    tags    = optional(map(string), null)
  }))
  default = {}
}

variable "aaaa_records" {
  description = "A map of DNS AAAA records to create in the Private DNS Zone. Each key represents the record name."
  type = map(object({
    ttl     = number
    records = list(string)
    tags    = optional(map(string), null)
  }))
  default = {}
}

variable "cname_records" {
  description = "A map of DNS CNAME records to create in the Private DNS Zone. Each key represents the record name."
  type = map(object({
    ttl    = number
    record = string
    tags   = optional(map(string), null)
  }))
  default = {}
}

variable "mx_records" {
  description = "A map of DNS MX records to create in the Private DNS Zone. Each key represents the record name."
  type = map(object({
    ttl = number
    record = map(object({
      preference = number
      exchange   = string
    }))
    tags = optional(map(string), null)
  }))
  default = {}
}

variable "ptr_records" {
  description = "A map of DNS PTR records to create in the Private DNS Zone. Each key represents the record name."
  type = map(object({
    ttl     = number
    records = list(string)
    tags    = optional(map(string), null)
  }))
  default = {}
}

variable "srv_records" {
  description = "A map of DNS SRV records to create in the Private DNS Zone. Each key represents the record name."
  type = map(object({
    ttl = number
    record = map(object({
      priority = number
      weight   = number
      port     = number
      target   = string
    }))
    tags = optional(map(string), null)
  }))
  default = {}
}

variable "txt_records" {
  description = "A map of DNS TXT records to create in the Private DNS Zone. Each key represents the record name."
  type = map(object({
    ttl = number
    record = map(object({
      value = string
    }))
    tags = optional(map(string), null)
  }))
  default = {}
}

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
  type = object({
    email        = string
    ttl          = number
    refresh_time = number
    retry_time   = number
  })
  default = null
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = null
}

variable "vnet_links" {
  description = "A map of virtual network links to associate with the Private DNS Zone. Each key represents a unique link name."
  type = map(object({
    virtual_network_id   = string
    registration_enabled = optional(bool, false)
    resolution_policy    = optional(string, null)
    tags                 = optional(map(string), null)
  }))
  default = {}
}