// Grant "Management Group Contributor" at Tenant Root to AzurePolicy UAMI


///////////////////////////////////////////////////



resource "azurerm_resource_group" "eastustest" {
  name = "test2"
  location = "eastus"
}

module "privatednszone" {
  source = "./Modules/azurerm_private_dns_zone"

  name = "testing.com"
  resource_group_name = azurerm_resource_group.eastustest.name
}





