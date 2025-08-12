resource "azurerm_public_ip" "this" {
    count               = var.ip_configuration.public_ip_address_id != null ? 0 : 1
  name                = "${var.name}-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "this" {
  copy_paste_enabled        = var.copy_paste_enabled
  file_copy_enabled         = var.file_copy_enabled
  ip_connect_enabled        = var.ip_connect_enabled
  kerberos_enabled          = var.kerberos_enabled
  name                      = var.name
  location                  = var.location
  resource_group_name       = var.resource_group_name
  scale_units               = var.scale_units
  shareable_link_enabled    = var.shareable_link_enabled
  session_recording_enabled = var.session_recording_enabled
  sku                       = var.sku
  tags                      = var.tags
  tunneling_enabled         = var.tunneling_enabled
  zones                     = var.zones

  ip_configuration {
    name                 = var.ip_configuration.name
    subnet_id            = var.ip_configuration.subnet_id
    public_ip_address_id = var.ip_configuration.public_ip_address_id != null ? var.ip_configuration.public_ip_address_id : azurerm_public_ip.this[0].id
  }
}
