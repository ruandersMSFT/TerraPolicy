resource "azurerm_private_dns_zone" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  tags = var.tags

  dynamic "soa_record" {
    for_each = (var.soa_records != null && length(var.soa_records) > 0) ? [var.soa_records[0]] : []

    content {
      email              = soa_record.value.email
      ttl               = soa_record.value.ttl
      refresh_time = soa_record.value.refresh_time
      retry_time       = soa_record.value.retry_time
    }
  }
}
