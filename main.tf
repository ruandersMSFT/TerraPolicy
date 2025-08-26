// Grant "Management Group Contributor" at Tenant Root to AzurePolicy UAMI


///////////////////////////////////////////////////



resource "azurerm_resource_group" "eastustest" {
  name     = "test2"
  location = "eastus"
}

module "privatednszone" {
  source = "./Modules/azurerm_private_dns_zone"

  name                = "testing.com"
  resource_group_name = azurerm_resource_group.eastustest.name
}



resource "azurerm_virtual_network" "example" {
  name                = "example"
  resource_group_name = azurerm_resource_group.eastustest.name
  location            = azurerm_resource_group.eastustest.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "AzureBastionSubnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.eastustest.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.64/27"]
}

resource "azurerm_subnet" "outbound" {
  name                 = "outbounddns"
  resource_group_name  = azurerm_resource_group.eastustest.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.0.64/28"]

  delegation {
    name = "Microsoft.Network.dnsResolvers"
    service_delegation {
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
      name    = "Microsoft.Network/dnsResolvers"
    }
  }
}

resource "azurerm_subnet" "inbound" {
  name                 = "inbounddns"
  resource_group_name  = azurerm_resource_group.eastustest.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.0.0/28"]

  delegation {
    name = "Microsoft.Network.dnsResolvers"
    service_delegation {
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
      name    = "Microsoft.Network/dnsResolvers"
    }
  }
}

/*
module "bastionhost" {
  source = "./Modules/azurerm_bastion_host"

  name                    = "example-bastion"
  resource_group_name     = azurerm_resource_group.eastustest.name  
  location                = azurerm_resource_group.eastustest.location
  virtual_network_id      = azurerm_virtual_network.example.id
  copy_paste_enabled      = true
  file_copy_enabled       = true
  ip_connect_enabled      = true
  kerberos_enabled        = false
  ip_configuration = {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.AzureBastionSubnet.id
    public_ip_address_id = "/subscriptions/12345678-1234-9876-4563-123456789012/resourceGroups/example-resource-group/providers/Microsoft.Network/publicIPAddresses/publicIPAddressesValue" //  null // Will use the default public IP created in the module
  }
  scale_units             = 2
  session_recording_enabled = false
  tags = {
    environment = "test"
    owner       = "devops"
  }
  sku = "Basic"
}
*/

/*
module "privatednsresolver" {
  source = "./Modules/azurerm_private_dns_resolver"

  name                    = "example"
  resource_group_name     = azurerm_resource_group.eastustest.name
  location                = azurerm_resource_group.eastustest.location
  virtual_network_id      = azurerm_virtual_network.example.id
  inbound_endpoint = {
    subnet_id                    = azurerm_subnet.inbound.id
  }
  outbound_endpoint = {
    subnet_id                    = azurerm_subnet.outbound.id
  }
  ruleset = {
    forwarding_rules = {
      "rule1" = {
        domain_name = "onprem.local."
        enabled     = true
        metadata    = { "environment" = "production" }
        target_dns_servers = [
          {
            ip_address = "10.10.0.1"
            port       = 53
          },
          {
            ip_address = "10.10.0.2"
            port       = 53
          }
        ]
      }
    }
    virtual_network_links = {
      "eastus" = {
        virtual_network_id = azurerm_virtual_network.example.id
      }
    }
  }
}
*/

data "azurerm_management_group" "cisanetmg" {
name = "cisanetmg"
}

module "p1" {
  source = "./Modules/azurerm_policy_definition"

  name = "test"
  display_name = "test"
  mode         = "All"
  policy_type = "Custom"
  management_group_id = data.azurerm_management_group.cisanetmg.id
  file_path = "./Policies/KeyVault/Premium.json"

  management_group_policy_assignments = {
    "CISANETMG" = {
      display_name         = "test"
      enforce              = true
      identity             = {
        type         = "SystemAssigned"
      }
      location             = "East US"
      management_group_id  = data.azurerm_management_group.cisanetmg.id
    }
  }

  subscription_policy_assignments = {
    "VisualStudioSubscription" = {
      display_name         = "test"
      enforce              = true
      identity             = {
        type         = "SystemAssigned"
      }
      location             = "East US"
      subscription_id      = "/subscriptions/070cfebd-3e63-42a5-ba50-58de1db7496e"
    }
  }
  
}