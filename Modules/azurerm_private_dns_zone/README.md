# Azure Private DNS Zone Terraform Module

This Terraform module creates an Azure Private DNS Zone with comprehensive DNS record management capabilities and virtual network link support for private DNS resolution within Azure virtual networks.

## Features

- ✅ **Complete DNS Record Support**: A, AAAA, CNAME, MX, PTR, SRV, TXT records
- ✅ **SOA Record Configuration**: Custom Start of Authority record settings
- ✅ **Virtual Network Links**: Link multiple VNets with registration and resolution policies
- ✅ **Flexible Record Management**: Map-based record creation with custom TTL and tags
- ✅ **Comprehensive Outputs**: Access to all record IDs and FQDNs
- ✅ **Tag Support**: Individual tagging for records and VNet links

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                  Azure Private DNS Zone                         │
│                    (contoso.private)                            │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  DNS Records:                     Virtual Network Links:        │
│  ┌─────────────────┐              ┌─────────────────┐           │
│  │ A Records       │              │ Hub VNet        │           │
│  │ web → 10.0.1.4  │              │ (Resolution)    │           │
│  │ api → 10.0.2.5  │              └─────────────────┘           │
│  └─────────────────┘                                            │
│                                   ┌─────────────────┐           │
│  ┌─────────────────┐              │ Spoke VNet 1    │           │
│  │ CNAME Records   │              │ (Registration)  │           │
│  │ www → web       │              └─────────────────┘           │
│  └─────────────────┘                                            │
│                                   ┌─────────────────┐           │
│  ┌─────────────────┐              │ Spoke VNet 2    │           │
│  │ SRV Records     │              │ (Resolution)    │           │
│  │ _sip._tcp       │              └─────────────────┘           │
│  └─────────────────┘                                            │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

## Usage

### Basic Example

```terraform
module "private_dns_zone" {
  source = "./Modules/azurerm_private_dns_zone"

  name                = "contoso.private"
  resource_group_name = "rg-dns"

  # Virtual Network Links
  vnet_links = {
    "hub-vnet" = {
      virtual_network_id   = "/subscriptions/.../virtualNetworks/vnet-hub"
      registration_enabled = false
    }
    "spoke-vnet" = {
      virtual_network_id   = "/subscriptions/.../virtualNetworks/vnet-spoke"
      registration_enabled = true
    }
  }

  # DNS A Records
  a_records = {
    "web" = {
      ttl     = 300
      records = ["10.0.1.4", "10.0.1.5"]
    }
    "api" = {
      ttl     = 300
      records = ["10.0.2.10"]
      tags = {
        Environment = "Production"
        Service     = "API"
      }
    }
  }

  # DNS CNAME Records
  cname_records = {
    "www" = {
      ttl    = 300
      record = "web.contoso.private"
    }
  }

  tags = {
    Environment = "Production"
    Project     = "Infrastructure"
  }
}
```

### Advanced Example with All Record Types

```terraform
module "comprehensive_dns_zone" {
  source = "./Modules/azurerm_private_dns_zone"

  name                = "enterprise.internal"
  resource_group_name = "rg-enterprise-dns"

  # Custom SOA Record
  soa_records = {
    email        = "admin.enterprise.internal"
    ttl          = 3600
    refresh_time = 3600
    retry_time   = 300
  }

  # A Records (IPv4)
  a_records = {
    "web-prod" = {
      ttl     = 300
      records = ["10.0.1.10", "10.0.1.11"]
      tags = {
        Environment = "Production"
        Tier        = "Web"
      }
    }
    "db-primary" = {
      ttl     = 600
      records = ["10.0.2.5"]
      tags = {
        Environment = "Production"
        Tier        = "Database"
        Role        = "Primary"
      }
    }
  }

  # AAAA Records (IPv6)
  aaaa_records = {
    "web-ipv6" = {
      ttl     = 300
      records = ["2001:db8::1", "2001:db8::2"]
      tags = {
        Environment = "Production"
        Protocol    = "IPv6"
      }
    }
  }

  # CNAME Records
  cname_records = {
    "www" = {
      ttl    = 300
      record = "web-prod.enterprise.internal"
    }
    "api" = {
      ttl    = 300
      record = "web-prod.enterprise.internal"
      tags = {
        Service = "API-Gateway"
      }
    }
  }

  # MX Records (Mail Exchange)
  mx_records = {
    "@" = {
      ttl = 3600
      record = {
        preference = 10
        exchange   = "mail.enterprise.internal"
      }
      tags = {
        Service = "Email"
      }
    }
  }

  # SRV Records (Service Records)
  srv_records = {
    "_sip._tcp" = {
      ttl = 300
      record = {
        priority = 10
        weight   = 60
        port     = 5060
        target   = "sip.enterprise.internal"
      }
      tags = {
        Service  = "SIP"
        Protocol = "TCP"
      }
    }
    "_ldap._tcp" = {
      ttl = 300
      record = {
        priority = 0
        weight   = 100
        port     = 389
        target   = "ldap.enterprise.internal"
      }
      tags = {
        Service = "LDAP"
      }
    }
  }

  # TXT Records
  txt_records = {
    "@" = {
      ttl = 300
      record = {
        value = "v=spf1 include:_spf.enterprise.internal ~all"
      }
      tags = {
        Purpose = "SPF"
      }
    }
    "_dmarc" = {
      ttl = 300
      record = {
        value = "v=DMARC1; p=quarantine; rua=mailto:dmarc@enterprise.internal"
      }
      tags = {
        Purpose = "DMARC"
      }
    }
  }

  # PTR Records (Reverse DNS)
  ptr_records = {
    "10" = {
      ttl     = 300
      records = ["web-prod.enterprise.internal"]
    }
  }

  # Virtual Network Links
  vnet_links = {
    "hub-network" = {
      virtual_network_id   = "/subscriptions/.../virtualNetworks/vnet-hub"
      registration_enabled = false
      resolution_policy    = "Default"
      tags = {
        Purpose     = "Hub-Connectivity"
        Environment = "Production"
      }
    }
    "spoke-web" = {
      virtual_network_id   = "/subscriptions/.../virtualNetworks/vnet-spoke-web"
      registration_enabled = true
      tags = {
        Purpose     = "Web-Workloads"
        Environment = "Production"
      }
    }
    "spoke-data" = {
      virtual_network_id   = "/subscriptions/.../virtualNetworks/vnet-spoke-data"
      registration_enabled = true
      tags = {
        Purpose     = "Data-Workloads"
        Environment = "Production"
      }
    }
  }

  tags = {
    Environment   = "Production"
    Project       = "Enterprise-DNS"
    Owner         = "Platform-Team"
    CostCenter    = "IT-Infrastructure"
    BusinessUnit  = "Enterprise"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| azurerm | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| azurerm | >= 3.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_private_dns_zone.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_a_record.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_a_record) | resource |
| [azurerm_private_dns_aaaa_record.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_aaaa_record) | resource |
| [azurerm_private_dns_cname_record.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_cname_record) | resource |
| [azurerm_private_dns_mx_record.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_mx_record) | resource |
| [azurerm_private_dns_ptr_record.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_ptr_record) | resource |
| [azurerm_private_dns_srv_record.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_srv_record) | resource |
| [azurerm_private_dns_txt_record.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_txt_record) | resource |
| [azurerm_private_dns_zone_virtual_network_link.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | The name of the Azure Private DNS Zone | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The resource group name for the Azure Private DNS Zone resource | `string` | n/a | yes |
| <a name="input_a_records"></a> [a\_records](#input\_a\_records) | A map of DNS A records to create in the Private DNS Zone | <pre>map(object({<br>    ttl     = number<br>    records = list(string)<br>    tags    = optional(map(string), null)<br>  }))</pre> | `{}` | no |
| <a name="input_aaaa_records"></a> [aaaa\_records](#input\_aaaa\_records) | A map of DNS AAAA records to create in the Private DNS Zone | <pre>map(object({<br>    ttl     = number<br>    records = list(string)<br>    tags    = optional(map(string), null)<br>  }))</pre> | `{}` | no |
| <a name="input_cname_records"></a> [cname\_records](#input\_cname\_records) | A map of DNS CNAME records to create in the Private DNS Zone | <pre>map(object({<br>    ttl    = number<br>    record = string<br>    tags   = optional(map(string), null)<br>  }))</pre> | `{}` | no |
| <a name="input_mx_records"></a> [mx\_records](#input\_mx\_records) | A map of DNS MX records to create in the Private DNS Zone | <pre>map(object({<br>    ttl = number<br>    record = object({<br>      preference = number<br>      exchange   = string<br>    })<br>    tags = optional(map(string), null)<br>  }))</pre> | `{}` | no |
| <a name="input_ptr_records"></a> [ptr\_records](#input\_ptr\_records) | A map of DNS PTR records to create in the Private DNS Zone | <pre>map(object({<br>    ttl     = number<br>    records = list(string)<br>    tags    = optional(map(string), null)<br>  }))</pre> | `{}` | no |
| <a name="input_srv_records"></a> [srv\_records](#input\_srv\_records) | A map of DNS SRV records to create in the Private DNS Zone | <pre>map(object({<br>    ttl = number<br>    record = object({<br>      priority = number<br>      weight   = number<br>      port     = number<br>      target   = string<br>    })<br>    tags = optional(map(string), null)<br>  }))</pre> | `{}` | no |
| <a name="input_txt_records"></a> [txt\_records](#input\_txt\_records) | A map of DNS TXT records to create in the Private DNS Zone | <pre>map(object({<br>    ttl = number<br>    record = object({<br>      value = string<br>    })<br>    tags = optional(map(string), null)<br>  }))</pre> | `{}` | no |
| <a name="input_soa_records"></a> [soa\_records](#input\_soa\_records) | A SOA record to create in the Private DNS Zone | <pre>object({<br>    email        = string<br>    ttl          = number<br>    refresh_time = number<br>    retry_time   = number<br>  })</pre> | `null` | no |
| <a name="input_vnet_links"></a> [vnet\_links](#input\_vnet\_links) | A map of virtual network links to associate with the Private DNS Zone | <pre>map(object({<br>    virtual_network_id   = string<br>    registration_enabled = optional(bool, false)<br>    resolution_policy    = optional(string, null)<br>    tags                 = optional(map(string), null)<br>  }))</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the resource | `map(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the Azure Private DNS Zone |
| <a name="output_a_record_ids"></a> [a\_record\_ids](#output\_a\_record\_ids) | Map of A record names to their IDs |
| <a name="output_a_record_fqdns"></a> [a\_record\_fqdns](#output\_a\_record\_fqdns) | Map of A record names to their FQDNs |
| <a name="output_aaaa_record_ids"></a> [aaaa\_record\_ids](#output\_aaaa\_record\_ids) | Map of AAAA record names to their IDs |
| <a name="output_aaaa_record_fqdns"></a> [aaaa\_record\_fqdns](#output\_aaaa\_record\_fqdns) | Map of AAAA record names to their FQDNs |
| <a name="output_cname_record_ids"></a> [cname\_record\_ids](#output\_cname\_record\_ids) | Map of CNAME record names to their IDs |
| <a name="output_cname_record_fqdns"></a> [cname\_record\_fqdns](#output\_cname\_record\_fqdns) | Map of CNAME record names to their FQDNs |
| <a name="output_mx_record_ids"></a> [mx\_record\_ids](#output\_mx\_record\_ids) | Map of MX record names to their IDs |
| <a name="output_mx_record_fqdns"></a> [mx\_record\_fqdns](#output\_mx\_record\_fqdns) | Map of MX record names to their FQDNs |
| <a name="output_ptr_record_ids"></a> [ptr\_record\_ids](#output\_ptr\_record\_ids) | Map of PTR record names to their IDs |
| <a name="output_ptr_record_fqdns"></a> [ptr\_record\_fqdns](#output\_ptr\_record\_fqdns) | Map of PTR record names to their FQDNs |
| <a name="output_srv_record_ids"></a> [srv\_record\_ids](#output\_srv\_record\_ids) | Map of SRV record names to their IDs |
| <a name="output_srv_record_fqdns"></a> [srv\_record\_fqdns](#output\_srv\_record\_fqdns) | Map of SRV record names to their FQDNs |
| <a name="output_txt_record_ids"></a> [txt\_record\_ids](#output\_txt\_record\_ids) | Map of TXT record names to their IDs |
| <a name="output_txt_record_fqdns"></a> [txt\_record\_fqdns](#output\_txt\_record\_fqdns) | Map of TXT record names to their FQDNs |
| <a name="output_virtual_network_link_ids"></a> [virtual\_network\_link\_ids](#output\_virtual\_network\_link\_ids) | Map of virtual network link names to their IDs |

## DNS Record Types

### A Records (IPv4 Address)
Map hostnames to IPv4 addresses. Supports multiple IP addresses for load balancing.

```terraform
a_records = {
  "web" = {
    ttl     = 300
    records = ["10.0.1.4", "10.0.1.5"]  # Multiple IPs for load balancing
  }
}
```

### AAAA Records (IPv6 Address)
Map hostnames to IPv6 addresses.

```terraform
aaaa_records = {
  "web-ipv6" = {
    ttl     = 300
    records = ["2001:db8::1"]
  }
}
```

### CNAME Records (Canonical Name)
Create aliases that point to other domain names.

```terraform
cname_records = {
  "www" = {
    ttl    = 300
    record = "web.contoso.private"  # Points to another domain
  }
}
```

### MX Records (Mail Exchange)
Define mail servers for the domain.

```terraform
mx_records = {
  "@" = {
    ttl = 3600
    record = {
      preference = 10        # Lower numbers have higher priority
      exchange   = "mail.contoso.private"
    }
  }
}
```

### SRV Records (Service)
Define services available in the domain.

```terraform
srv_records = {
  "_sip._tcp" = {
    ttl = 300
    record = {
      priority = 10         # Lower numbers have higher priority
      weight   = 60         # Relative weight for same priority
      port     = 5060       # Service port
      target   = "sip.contoso.private"
    }
  }
}
```

### TXT Records (Text)
Store arbitrary text data, commonly used for verification and policies.

```terraform
txt_records = {
  "@" = {
    ttl = 300
    record = {
      value = "v=spf1 include:_spf.contoso.com ~all"
    }
  }
}
```

### PTR Records (Pointer)
Reverse DNS lookups, map IP addresses back to hostnames.

```terraform
ptr_records = {
  "10" = {
    ttl     = 300
    records = ["web.contoso.private"]
  }
}
```

## Virtual Network Links

Virtual network links connect Azure virtual networks to the private DNS zone for name resolution.

### Registration vs Resolution

- **Registration Enabled**: VMs in the VNet automatically register their hostnames
- **Registration Disabled**: Manual DNS record management only
- **Resolution**: All linked VNets can resolve DNS names in the zone

```terraform
vnet_links = {
  "hub-vnet" = {
    virtual_network_id   = "/subscriptions/.../virtualNetworks/vnet-hub"
    registration_enabled = false  # Manual DNS record management
    resolution_policy    = "Default"
  }
  "spoke-vnet" = {
    virtual_network_id   = "/subscriptions/.../virtualNetworks/vnet-spoke"
    registration_enabled = true   # Auto-register VM hostnames
  }
}
```

## Important Notes

### Zone Naming
- Use reverse domain notation (e.g., `contoso.private`, `internal.company.com`)
- Avoid conflicts with public DNS zones
- Consider using `.private`, `.internal`, or `.local` suffixes

### TTL Considerations
- **Low TTL (60-300s)**: Frequently changing records, faster failover
- **High TTL (3600s+)**: Stable records, better performance, lower DNS load

### Record Limitations
- **CNAME**: Cannot coexist with other record types at the same name
- **MX/SRV**: Require FQDN targets (must end with a dot or be fully qualified)
- **PTR**: Typically used in reverse lookup zones (e.g., `10.in-addr.arpa`)

### Best Practices
1. **Use consistent TTL values** based on change frequency
2. **Tag resources** for better organization and cost tracking
3. **Separate environments** with different DNS zones
4. **Monitor DNS resolution** for performance and availability
5. **Document DNS architecture** for operational teams

## Common Use Cases

### 1. Internal Application DNS
```terraform
module "app_dns" {
  source = "./Modules/azurerm_private_dns_zone"
  
  name                = "app.internal"
  resource_group_name = "rg-applications"
  
  a_records = {
    "api"      = { ttl = 300, records = ["10.0.1.10"] }
    "database" = { ttl = 600, records = ["10.0.2.5"] }
    "cache"    = { ttl = 300, records = ["10.0.3.8"] }
  }
  
  cname_records = {
    "www" = { ttl = 300, record = "api.app.internal" }
  }
}
```

### 2. Service Discovery
```terraform
module "services_dns" {
  source = "./Modules/azurerm_private_dns_zone"
  
  name                = "services.internal"
  resource_group_name = "rg-microservices"
  
  srv_records = {
    "_http._tcp.api" = {
      ttl = 300
      record = {
        priority = 10
        weight   = 100
        port     = 8080
        target   = "api-server.services.internal"
      }
    }
  }
}
```

### 3. Multi-Region Setup
```terraform
module "global_dns" {
  source = "./Modules/azurerm_private_dns_zone"
  
  name                = "global.company.internal"
  resource_group_name = "rg-global-dns"
  
  a_records = {
    "eastus-api"  = { ttl = 300, records = ["10.1.0.10"] }
    "westus-api"  = { ttl = 300, records = ["10.2.0.10"] }
  }
  
  # Global load balanced endpoint
  a_records = {
    "api" = { 
      ttl = 60,  # Low TTL for fast failover
      records = ["10.1.0.10", "10.2.0.10"] 
    }
  }
}
```

## License

This module is provided under the MIT License. See LICENSE file for details.