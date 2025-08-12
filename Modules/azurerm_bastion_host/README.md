# Azure Bastion Host Terraform Module

This Terraform module creates an Azure Bastion Host with optional public IP address creation and comprehensive configuration options.

## Features

- ✅ **Automatic Public IP Creation**: Creates a public IP if not provided
- ✅ **Flexible SKU Support**: Supports Basic and Standard SKUs
- ✅ **Advanced Features**: File copy, session recording, tunneling, and more
- ✅ **Zone Redundancy**: Optional availability zone configuration
- ✅ **Scaling**: Configurable scale units for Standard SKU

## Usage

### Basic Example

```terraform
module "bastion_host" {
  source = "./Modules/azurerm_bastion_host"

  name                = "my-bastion-host"
  location            = "East US"
  resource_group_name = "my-resource-group"

  ip_configuration = {
    name      = "bastion-ip-config"
    subnet_id = "/subscriptions/.../subnets/AzureBastionSubnet"
    # public_ip_address_id will be auto-created
  }

  tags = {
    Environment = "Production"
    Project     = "Infrastructure"
  }
}
```

### Advanced Example with Custom Public IP

```terraform
# Create your own public IP
resource "azurerm_public_ip" "bastion_pip" {
  name                = "bastion-public-ip"
  location            = "East US"
  resource_group_name = "my-resource-group"
  allocation_method   = "Static"
  sku                 = "Standard"
  
  tags = {
    Environment = "Production"
  }
}

module "bastion_host" {
  source = "./Modules/azurerm_bastion_host"

  name                = "advanced-bastion-host"
  location            = "East US"
  resource_group_name = "my-resource-group"
  sku                 = "Standard"
  scale_units         = 4

  # Enable advanced features (requires Standard SKU)
  copy_paste_enabled        = true
  file_copy_enabled         = true
  ip_connect_enabled        = true
  session_recording_enabled = true
  shareable_link_enabled    = true
  tunneling_enabled         = true
  kerberos_enabled          = false

  ip_configuration = {
    name                 = "bastion-ip-config"
    subnet_id            = "/subscriptions/.../subnets/AzureBastionSubnet"
    public_ip_address_id = azurerm_public_ip.bastion_pip.id
  }

  zones = ["1", "2", "3"]

  tags = {
    Environment = "Production"
    Project     = "Infrastructure"
    SKU         = "Standard"
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
| [azurerm_bastion_host.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/bastion_host) | resource |
| [azurerm_public_ip.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | The name of the Azure Bastion Host | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The location where the Azure Bastion Host will be created | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The resource group name for the Azure Bastion Host resource | `string` | n/a | yes |
| <a name="input_ip_configuration"></a> [ip\_configuration](#input\_ip\_configuration) | Configuration for the IP settings of the Azure Bastion Host | <pre>object({<br>    name                 = string<br>    subnet_id            = string<br>    public_ip_address_id = optional(string, null)<br>  })</pre> | n/a | yes |
| <a name="input_copy_paste_enabled"></a> [copy\_paste\_enabled](#input\_copy\_paste\_enabled) | Enable copy-paste functionality for the Azure Bastion Host | `bool` | `true` | no |
| <a name="input_file_copy_enabled"></a> [file\_copy\_enabled](#input\_file\_copy\_enabled) | Enable file copy functionality for the Azure Bastion Host | `bool` | `false` | no |
| <a name="input_ip_connect_enabled"></a> [ip\_connect\_enabled](#input\_ip\_connect\_enabled) | Enable IP connect functionality for the Azure Bastion Host | `bool` | `false` | no |
| <a name="input_kerberos_enabled"></a> [kerberos\_enabled](#input\_kerberos\_enabled) | Enable Kerberos authentication for the Azure Bastion Host | `bool` | `false` | no |
| <a name="input_scale_units"></a> [scale\_units](#input\_scale\_units) | The number of scale units for the Azure Bastion Host | `number` | `2` | no |
| <a name="input_session_recording_enabled"></a> [session\_recording\_enabled](#input\_session\_recording\_enabled) | Enable session recording for the Azure Bastion Host | `bool` | `false` | no |
| <a name="input_shareable_link_enabled"></a> [shareable\_link\_enabled](#input\_shareable\_link\_enabled) | Enable shareable link functionality for the Azure Bastion Host | `bool` | `false` | no |
| <a name="input_sku"></a> [sku](#input\_sku) | The SKU of the Azure Bastion Host | `string` | `"Basic"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the Azure Bastion Host | `map(string)` | `null` | no |
| <a name="input_tunneling_enabled"></a> [tunneling\_enabled](#input\_tunneling\_enabled) | Enable tunneling functionality for the Azure Bastion Host | `bool` | `false` | no |
| <a name="input_virtual_network_id"></a> [virtual\_network\_id](#input\_virtual\_network\_id) | The ID of the virtual network to which the Azure Bastion Host will be connected | `string` | `null` | no |
| <a name="input_zones"></a> [zones](#input\_zones) | A list of availability zones for the Azure Bastion Host | `list(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dns_name"></a> [dns\_name](#output\_dns\_name) | The DNS name of the Azure Bastion Host |
| <a name="output_id"></a> [id](#output\_id) | The ID of the Azure Bastion Host |
| <a name="output_public_ip_address_id"></a> [public\_ip\_address\_id](#output\_public\_ip\_address\_id) | The ID of the public IP address associated with the Azure Bastion Host |

## Important Notes

### Subnet Requirements
- The subnet specified in `ip_configuration.subnet_id` **must** be named `AzureBastionSubnet`
- The subnet must have a minimum size of `/26` (64 addresses)
- The subnet must be dedicated to Azure Bastion (no other resources)

### SKU Limitations
- **Basic SKU**: Limited to basic connectivity features
- **Standard SKU**: Required for advanced features like:
  - File copy (`file_copy_enabled`)
  - IP connect (`ip_connect_enabled`) 
  - Session recording (`session_recording_enabled`)
  - Shareable links (`shareable_link_enabled`)
  - Tunneling (`tunneling_enabled`)
  - Scale units > 2

### Public IP Address
- If `public_ip_address_id` is not provided, the module will automatically create a Standard SKU static public IP
- If provided, the public IP must be Standard SKU with static allocation
- The public IP must be in the same location and resource group as the Bastion Host

### Scale Units
- Basic SKU: Fixed at 2 scale units
- Standard SKU: 2-50 scale units (each unit supports ~20 concurrent connections)

## Examples

### Minimal Configuration
```terraform
module "bastion_basic" {
  source = "./Modules/azurerm_bastion_host"

  name                = "basic-bastion"
  location            = "East US"
  resource_group_name = "rg-networking"
  
  ip_configuration = {
    name      = "bastion-config"
    subnet_id = "/subscriptions/xxx/resourceGroups/rg-networking/providers/Microsoft.Network/virtualNetworks/vnet-main/subnets/AzureBastionSubnet"
  }
}
```

### High Availability Configuration
```terraform
module "bastion_ha" {
  source = "./Modules/azurerm_bastion_host"

  name                = "ha-bastion"
  location            = "East US"
  resource_group_name = "rg-networking"
  sku                 = "Standard"
  scale_units         = 10
  zones               = ["1", "2", "3"]
  
  # Enable advanced features
  file_copy_enabled         = true
  session_recording_enabled = true
  ip_connect_enabled        = true
  
  ip_configuration = {
    name      = "bastion-config"
    subnet_id = "/subscriptions/xxx/resourceGroups/rg-networking/providers/Microsoft.Network/virtualNetworks/vnet-main/subnets/AzureBastionSubnet"
  }

  tags = {
    Environment = "Production"
    Tier        = "Critical"
  }
}
```

## License

This module is provided under the MIT License. See LICENSE file for details.