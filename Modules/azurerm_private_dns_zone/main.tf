resource "azurerm_private_dns_zone" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  tags                = var.tags

  dynamic "soa_record" {
    for_each = (var.soa_records != null) ? [var.soa_records] : []

    content {
      email        = soa_record.value.email
      ttl          = soa_record.value.ttl
      refresh_time = soa_record.value.refresh_time
      retry_time   = soa_record.value.retry_time
    }
  }
}

resource "azurerm_private_dns_a_record" "this" {
  for_each            = var.a_records
  name                = each.key
  resource_group_name = var.resource_group_name
  zone_name           = azurerm_private_dns_zone.this.name
  ttl                 = each.value.ttl
  records             = lookup(each.value, "records", null)
  tags                = lookup(each.value, "tags", null)
}

resource "azurerm_private_dns_aaaa_record" "this" {
  for_each            = var.aaaa_records
  name                = each.key
  resource_group_name = var.resource_group_name
  zone_name           = azurerm_private_dns_zone.this.name
  ttl                 = each.value.ttl
  records             = lookup(each.value, "records", null)
  tags                = lookup(each.value, "tags", null)
}

resource "azurerm_private_dns_cname_record" "this" {
  for_each            = var.cname_records
  name                = each.key
  resource_group_name = var.resource_group_name
  zone_name           = azurerm_private_dns_zone.this.name
  ttl                 = each.value.ttl
  record              = each.value.record
  tags                = lookup(each.value, "tags", null)
}

resource "azurerm_private_dns_mx_record" "this" {
  for_each            = var.mx_records
  name                = each.key
  resource_group_name = var.resource_group_name
  zone_name           = azurerm_private_dns_zone.this.name
  ttl                 = each.value.ttl
  tags                = lookup(each.value, "tags", null)

  dynamic "record" {
    for_each = [each.value.record]
    content {
      preference = record.value.preference
      exchange   = record.value.exchange
    }
  }
}

resource "azurerm_private_dns_ptr_record" "this" {
  for_each            = var.ptr_records
  name                = each.key
  resource_group_name = var.resource_group_name
  zone_name           = azurerm_private_dns_zone.this.name
  ttl                 = each.value.ttl
  records             = lookup(each.value, "records", null)
  tags                = lookup(each.value, "tags", null)
}

resource "azurerm_private_dns_srv_record" "this" {
  for_each            = var.srv_records
  name                = each.key
  resource_group_name = var.resource_group_name
  zone_name           = azurerm_private_dns_zone.this.name
  ttl                 = each.value.ttl
  tags                = lookup(each.value, "tags", null)

  dynamic "record" {
    for_each = [each.value.record]
    content {
      priority = record.value.priority
      weight   = record.value.weight
      port     = record.value.port
      target   = record.value.target
    }
  }
}

resource "azurerm_private_dns_txt_record" "this" {
  for_each            = var.txt_records
  name                = each.key
  resource_group_name = var.resource_group_name
  zone_name           = azurerm_private_dns_zone.this.name
  ttl                 = each.value.ttl
  tags                = lookup(each.value, "tags", null)

  dynamic "record" {
    for_each = [each.value.record]
    content {
      value = record.value.value
    }
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  for_each              = var.vnet_links
  name                  = "dns-vnet-link-${each.key}"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.this.name
  virtual_network_id    = each.value.virtual_network_id
  registration_enabled  = lookup(each.value, "registration_enabled", false)
  resolution_policy     = lookup(each.value, "resolution_policy", null)
  tags                  = lookup(each.value, "tags", null)
}