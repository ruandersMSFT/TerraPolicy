# Azure Private DNS Resolver Terraform Module

This Terraform module creates an Azure Private DNS Resolver with inbound and outbound endpoints, DNS forwarding rules, and virtual network links for hybrid DNS resolution scenarios.

## Features

- ✅ **Complete DNS Resolver Setup**: Creates resolver with inbound and outbound endpoints
- ✅ **Flexible Forwarding Rules**: Support for multiple DNS forwarding rules with custom target servers
- ✅ **Virtual Network Links**: Link multiple virtual networks to the DNS forwarding ruleset
- ✅ **Custom Target DNS Servers**: Configure multiple DNS servers with custom ports
- ✅ **Metadata Support**: Add custom metadata to rules and virtual network links
- ✅ **Dynamic IP Configuration**: Support for both static and dynamic IP allocation

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                     Azure Private DNS Resolver                  │
├─────────────────────────────────────────────────────────────────┤
│  ┌─────────────────┐              ┌─────────────────┐           │
│  │ Inbound Endpoint │              │Outbound Endpoint│           │
│  │   (Subnet A)     │              │   (Subnet B)    │           │
│  └─────────────────┘              └─────────────────┘           │
│           │                                 │                   │
│           │          ┌─────────────────────┼─────────────────┐  │
│           │          │  DNS Forwarding     │                 │  │
│           │          │     Ruleset         │                 │  │
│           │          │                     │                 │  │
│           │          │  ┌─────────────────┐│                 │  │
│           │          │  │ Forwarding Rules││                 │  │
│           │          │  │ example.com →   ││                 │  │
│           │          │  │ 10.0.1.4:53     ││                 │  │
│           │          │  └─────────────────┘│                 │  │
│           │          │                     │                 │  │
│           │          │  ┌─────────────────┐│                 │  │
│           │          │  │ VNet Links      ││                 │  │
│           │          │  │ Spoke VNets     ││                 │  │
│           │          │  └─────────────────┘│                 │  │
│           │          └─────────────────────┼─────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
```

## Usage

### Basic Example

```terraform
module "dns_resolver" {
  source = "./Modules/azurerm_private_dns_resolver"

  name                = "my-dns-resolver"
  location            = "East US"
  resource_group_name = "rg-dns"
  virtual_network_id  = "/subscriptions/.../virtualNetworks/hub-vnet"

  inbound_endpoint = {
    subnet_id                    = "/subscriptions/.../subnets/dns-inbound-subnet"
    private_ip_allocation_method = "Dynamic"
  }

  outbound_endpoint = {
    subnet_id = "/subscriptions/.../subnets/dns-outbound-subnet"
  }

  ruleset = {
    forwarding_rules = {
      "corp-domain" = {
        domain_name = "corp.contoso.com"
        enabled     = true
        target_dns_servers = [
          {
            ip_address = "10.0.1.4"
            port       = 53
          }
        ]
      }
    }
    
    virtual_network_links = {
      "spoke-vnet-1" = {
        virtual_network_id = "/subscriptions/.../virtualNetworks/spoke-vnet-1"
      }
    }
  }

  tags = {
    Environment = "Production"
    Purpose     = "Hybrid DNS"
  }
}
```

### Advanced Example with Multiple Rules and Target Servers

```terraform
module "enterprise_dns_resolver" {
  source = "./Modules/azurerm_private_dns_resolver"

  name                = "enterprise-dns-resolver"
  location            = "East US"
  resource_group_name = "rg-networking"
  virtual_network_id  = "/subscriptions/.../virtualNetworks/hub-vnet"

  inbound_endpoint = {
    subnet_id                    = "/subscriptions/.../subnets/dns-inbound-subnet"
    private_ip_allocation_method = "Static"
    private_ip_address          = "10.0.1.10"
  }

  outbound_endpoint = {
    subnet_id = "/subscriptions/.../subnets/dns-outbound-subnet"
  }

  ruleset = {
    forwarding_rules = {
      "corp-domain" = {
        domain_name = "corp.contoso.com"
        enabled     = true
        metadata = {
          owner       = "IT-Team"
          environment = "production"
        }
        target_dns_servers = [
          {
            ip_address = "10.0.1.4"
            port       = 53
          },
          {
            ip_address = "10.0.1.5"
            port       = 53
          }
        ]
      }
      
      "dev-domain" = {
        domain_name = "dev.contoso.com"
        enabled     = true
        metadata = {
          owner       = "Dev-Team"
          environment = "development"
        }
        target_dns_servers = [
          {
            ip_address = "10.1.1.4"
            port       = 5353
          }
        ]
      }
      
      "external-partner" = {
        domain_name = "partner.external.com"
        enabled     = false
        metadata = {
          owner  = "Security-Team"
          status = "under-review"
        }
        target_dns_servers = [
          {
            ip_address = "192.168.1.10"
          }
        ]
      }
    }
    
    virtual_network_links = {
      "spoke-production" = {
        virtual_network_id = "/subscriptions/.../virtualNetworks/spoke-prod-vnet"
        metadata = {
          environment = "production"
          tier        = "critical"
        }
      }
      
      "spoke-development" = {
        virtual_network_id = "/subscriptions/.../virtualNetworks/spoke-dev-vnet"
        metadata = {
          environment = "development"
          tier        = "standard"
        }
      }
      
      "spoke-staging" = {
        virtual_network_id = "/subscriptions/.../virtualNetworks/spoke-staging-vnet"
        metadata = {
          environment = "staging"
          tier        = "standard"
        }
      }
    }
  }

  tags = {
    Environment = "Production"
    Project     = "Enterprise-DNS"
    Owner       = "Platform-Team"
    CostCenter  = "IT-Infrastructure"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| azurerm | >= 3.74 |

## Providers

| Name | Version |
|------|---------|
| azurerm | >= 3.74 |

## Resources

| Name | Type |
|------|------|
| [azurerm_private_dns_resolver.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_resolver) | resource |
| [azurerm_private_dns_resolver_inbound_endpoint.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_resolver_inbound_endpoint) | resource |
| [azurerm_private_dns_resolver_outbound_endpoint.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_resolver_outbound_endpoint) | resource |
| [azurerm_private_dns_resolver_dns_forwarding_ruleset.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_resolver_dns_forwarding_ruleset) | resource |
| [azurerm_private_dns_resolver_forwarding_rule.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_resolver_forwarding_rule) | resource |
| [azurerm_private_dns_resolver_virtual_network_link.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_resolver_virtual_network_link) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | The name of the Azure Private DNS Resolver | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The location where the Azure Private DNS Resolver will be created | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The resource group name for the Azure Private DNS Resolver resource | `string` | n/a | yes |
| <a name="input_virtual_network_id"></a> [virtual\_network\_id](#input\_virtual\_network\_id) | The ID of the virtual network to associate with the Azure Private DNS Resolver | `string` | n/a | yes |
| <a name="input_inbound_endpoint"></a> [inbound\_endpoint](#input\_inbound\_endpoint) | Configuration for the inbound endpoint of the Azure Private DNS Resolver | <pre>object({<br>    private_ip_address           = optional(string, null)<br>    private_ip_allocation_method = optional(string, "Dynamic")<br>    subnet_id                    = string<br>  })</pre> | n/a | yes |
| <a name="input_outbound_endpoint"></a> [outbound\_endpoint](#input\_outbound\_endpoint) | Configuration for the outbound endpoint of the Azure Private DNS Resolver | <pre>object({<br>    subnet_id = string<br>  })</pre> | n/a | yes |
| <a name="input_ruleset"></a> [ruleset](#input\_ruleset) | A map of DNS forwarding rulesets to create in the Azure Private DNS Resolver | <pre>object({<br>    forwarding_rules = map(object({<br>      domain_name = string<br>      enabled     = bool<br>      metadata    = optional(map(string), {})<br>      target_dns_servers = list(object({<br>        ip_address = string<br>        port       = optional(number, 53)<br>      }))<br>    }))<br>    virtual_network_links = map(object({<br>      virtual_network_id = string<br>      metadata           = optional(map(string), {})<br>    }))<br>  })</pre> | <pre>{<br>  "forwarding_rules": {},<br>  "virtual_network_links": {}<br>}</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the Azure Private DNS Resolver | `map(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the Azure Private DNS Resolver |

## Important Notes

### Subnet Requirements

1. **Inbound Endpoint Subnet**:
   - Must be dedicated to the DNS resolver inbound endpoint
   - Minimum size: `/28` (16 addresses)
   - Cannot be shared with other resources

2. **Outbound Endpoint Subnet**:
   - Must be dedicated to the DNS resolver outbound endpoint  
   - Minimum size: `/28` (16 addresses)
   - Cannot be shared with other resources

3. **Subnet Delegation**:
   - Both subnets must be delegated to `Microsoft.Network/dnsResolvers`

### DNS Forwarding Rules

- **Domain Names**: Must be fully qualified domain names (FQDN)
- **Target DNS Servers**: Can specify custom ports (default: 53)
- **Rule Priority**: Rules are evaluated in alphabetical order by name
- **Wildcard Support**: Supports wildcard domains (e.g., `*.contoso.com`)

### Virtual Network Links

- Links virtual networks to the DNS forwarding ruleset
- Linked VNets can resolve domains defined in forwarding rules
- Maximum 1000 virtual network links per DNS forwarding ruleset

### Limitations

- Maximum 25 DNS forwarding rules per ruleset
- Maximum 6 target DNS servers per forwarding rule
- DNS resolver must be in the same region as the virtual network
- Inbound and outbound endpoints must be in different subnets

## Common Use Cases

### 1. Hybrid DNS Resolution
Route specific domains to on-premises DNS servers while keeping Azure DNS for Azure resources.

### 2. Multi-Cloud DNS
Forward domains to DNS servers in other cloud providers or external partners.

### 3. Development Environment Separation
Route development domains to separate DNS infrastructure.

### 4. Conditional Forwarding
Forward specific domains based on business requirements or security policies.

## Example: Complete Hub-Spoke DNS Setup

```terraform
# Create resource group
resource "azurerm_resource_group" "dns" {
  name     = "rg-dns-resolver"
  location = "East US"
}

# Create virtual network
resource "azurerm_virtual_network" "hub" {
  name                = "vnet-hub"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.dns.location
  resource_group_name = azurerm_resource_group.dns.name
}

# Create subnets for DNS resolver
resource "azurerm_subnet" "dns_inbound" {
  name                 = "snet-dns-inbound"
  resource_group_name  = azurerm_resource_group.dns.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = ["10.0.1.0/28"]

  delegation {
    name = "Microsoft.Network.dnsResolvers"
    service_delegation {
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
      name    = "Microsoft.Network/dnsResolvers"
    }
  }
}

resource "azurerm_subnet" "dns_outbound" {
  name                 = "snet-dns-outbound"
  resource_group_name  = azurerm_resource_group.dns.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = ["10.0.2.0/28"]

  delegation {
    name = "Microsoft.Network.dnsResolvers"
    service_delegation {
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
      name    = "Microsoft.Network/dnsResolvers"
    }
  }
}

# Deploy DNS resolver
module "dns_resolver" {
  source = "./Modules/azurerm_private_dns_resolver"

  name                = "dns-resolver-hub"
  location            = azurerm_resource_group.dns.location
  resource_group_name = azurerm_resource_group.dns.name
  virtual_network_id  = azurerm_virtual_network.hub.id

  inbound_endpoint = {
    subnet_id                    = azurerm_subnet.dns_inbound.id
    private_ip_allocation_method = "Dynamic"
  }

  outbound_endpoint = {
    subnet_id = azurerm_subnet.dns_outbound.id
  }

  ruleset = {
    forwarding_rules = {
      "onpremises" = {
        domain_name = "corp.contoso.com"
        enabled     = true
        target_dns_servers = [
          {
            ip_address = "192.168.1.10"
            port       = 53
          }
        ]
      }
    }
    
    virtual_network_links = {
      "spoke-workloads" = {
        virtual_network_id = "/subscriptions/.../virtualNetworks/vnet-spoke-workloads"
      }
    }
  }

  tags = {
    Environment = "Production"
    Purpose     = "Hybrid-DNS"
  }

  depends_on = [
    azurerm_subnet.dns_inbound,
    azurerm_subnet.dns_outbound
  ]
}
```

## License

This module is provided under the MIT License. See LICENSE file for details.