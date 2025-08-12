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
