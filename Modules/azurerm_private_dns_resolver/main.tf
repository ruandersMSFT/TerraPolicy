resource "azurerm_private_dns_resolver" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  virtual_network_id  = var.virtual_network_id
  tags                = var.tags
}

resource "azurerm_private_dns_resolver_inbound_endpoint" "this" {
  name                    = var.name
  private_dns_resolver_id = azurerm_private_dns_resolver.this.id
  location                = azurerm_private_dns_resolver.this.location
  tags                    = var.tags

  ip_configurations {
    private_ip_address           = var.inbound_endpoint.private_ip_address
    private_ip_allocation_method = var.inbound_endpoint.private_ip_allocation_method
    subnet_id                    = var.inbound_endpoint.subnet_id
  }
}

resource "azurerm_private_dns_resolver_outbound_endpoint" "this" {
  name                    = var.name
  private_dns_resolver_id = azurerm_private_dns_resolver.this.id
  location                = azurerm_private_dns_resolver.this.location
  subnet_id               = var.outbound_endpoint.subnet_id
  tags                    = var.tags
}

resource "azurerm_private_dns_resolver_dns_forwarding_ruleset" "this" {
  name                                       = var.name
  resource_group_name                        = var.resource_group_name
  location                                   = var.location
  private_dns_resolver_outbound_endpoint_ids = [azurerm_private_dns_resolver_outbound_endpoint.this.id]
  tags                                       = var.tags
}

resource "azurerm_private_dns_resolver_forwarding_rule" "this" {
  for_each                  = var.ruleset.forwarding_rules
  name                      = each.key
  dns_forwarding_ruleset_id = azurerm_private_dns_resolver_dns_forwarding_ruleset.this.id
  domain_name               = each.value.domain_name
  enabled                   = each.value.enabled
  metadata                  = each.value.metadata

  dynamic "target_dns_servers" {
    for_each = each.value.target_dns_servers
    content {
      ip_address = target_dns_servers.value.ip_address
      port       = target_dns_servers.value.port
    }
  }
}

resource "azurerm_private_dns_resolver_virtual_network_link" "this" {
  for_each                  = var.ruleset.virtual_network_links
  name                      = each.key
  dns_forwarding_ruleset_id = azurerm_private_dns_resolver_dns_forwarding_ruleset.this.id
  virtual_network_id        = each.value.virtual_network_id
  metadata                  = each.value.metadata
}
