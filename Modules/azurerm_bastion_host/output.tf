output "dns_name" {
  value = azurerm_bastion_host.this.dns_name
}

output "id" {
  value = azurerm_bastion_host.this.id
}

output "public_ip_address_id" {
  description = "The ID of the public IP address associated with the Azure Bastion Host."
  value       = var.ip_configuration.public_ip_address_id != null ? var.ip_configuration.public_ip_address_id : azurerm_public_ip.this[0].id
}
