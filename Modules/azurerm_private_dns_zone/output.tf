output "a_record_ids" {
  description = "Map of A record names to their IDs"
  value       = { for k, v in azurerm_private_dns_a_record.this : k => v.id }
}

output "a_record_fqdns" {
  description = "Map of A record names to their FQDNs"
  value       = { for k, v in azurerm_private_dns_a_record.this : k => v.fqdn }
}

output "aaaa_record_ids" {
  description = "Map of AAAA record names to their IDs"
  value       = { for k, v in azurerm_private_dns_aaaa_record.this : k => v.id }
}

output "aaaa_record_fqdns" {
  description = "Map of AAAA record names to their FQDNs"
  value       = { for k, v in azurerm_private_dns_aaaa_record.this : k => v.fqdn }
}

output "cname_record_ids" {
  description = "Map of CNAME record names to their IDs"
  value       = { for k, v in azurerm_private_dns_cname_record.this : k => v.id }
}

output "cname_record_fqdns" {
  description = "Map of CNAME record names to their FQDNs"
  value       = { for k, v in azurerm_private_dns_cname_record.this : k => v.fqdn }
}

output "id" {
  value = azurerm_private_dns_zone.this.id
}

output "mx_record_ids" {
  description = "Map of MX record names to their IDs"
  value       = { for k, v in azurerm_private_dns_mx_record.this : k => v.id }
}

output "mx_record_fqdns" {
  description = "Map of MX record names to their FQDNs"
  value       = { for k, v in azurerm_private_dns_mx_record.this : k => v.fqdn }
}

output "ptr_record_ids" {
  description = "Map of PTR record names to their IDs"
  value       = { for k, v in azurerm_private_dns_ptr_record.this : k => v.id }
}

output "ptr_record_fqdns" {
  description = "Map of PTR record names to their FQDNs"
  value       = { for k, v in azurerm_private_dns_ptr_record.this : k => v.fqdn }
}

output "srv_record_ids" {
  description = "Map of SRV record names to their IDs"
  value       = { for k, v in azurerm_private_dns_srv_record.this : k => v.id }
}

output "srv_record_fqdns" {
  description = "Map of SRV record names to their FQDNs"
  value       = { for k, v in azurerm_private_dns_srv_record.this : k => v.fqdn }
}

output "txt_record_ids" {
  description = "Map of TXT record names to their IDs"
  value       = { for k, v in azurerm_private_dns_txt_record.this : k => v.id }
}

output "txt_record_fqdns" {
  description = "Map of TXT record names to their FQDNs"
  value       = { for k, v in azurerm_private_dns_txt_record.this : k => v.fqdn }
}

output "virtual_network_link_ids" {
  description = "Map of virtual network link names to their IDs"
  value       = { for k, v in azurerm_private_dns_zone_virtual_network_link.this : k => v.id }
}
