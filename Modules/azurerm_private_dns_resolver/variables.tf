variable "inbound_endpoint" {
  description = "Configuration for the inbound endpoint of the Azure Private DNS Resolver."
  type = object({
    private_ip_address           = optional(string, null)
    private_ip_allocation_method = optional(string, "Dynamic")
    subnet_id                    = string
  })
}

variable "location" {
  description = "The location where the Azure Private DNS Resolver will be created."
  type        = string
}

variable "name" {
  description = "The name of the Azure Private DNS Resolver."
  type        = string
}

variable "outbound_endpoint" {
  description = "Configuration for the outbound endpoint of the Azure Private DNS Resolver."
  type = object({
    subnet_id                    = string
  })
}

variable "resource_group_name" {
  description = "The resource group name for the Azure Private DNS Resolver resource."
  type        = string
}

variable "ruleset" {
  description = "A map of DNS forwarding rulesets to create in the Azure Private DNS Resolver. Each key represents a unique ruleset name."
  type = object({
    forwarding_rules = map(object({
      domain_name = string
      enabled     = bool
      metadata    = optional(map(string), {})
      target_dns_servers = list(object({
        ip_address = string
        port       = optional(number, 53)
      }))
    }))
    virtual_network_links = map(object({
      virtual_network_id = string
      metadata           = optional(map(string), {})
    }))
  })
  default = {
    forwarding_rules      = {}
    virtual_network_links = {}
  }
}

variable "tags" {
  description = "A mapping of tags to assign to the Azure Private DNS Resolver."
  type        = map(string)
  default     = null
}

variable "virtual_network_id" {
  description = "The ID of the virtual network to associate with the Azure Private DNS Resolver."
  type        = string
}

