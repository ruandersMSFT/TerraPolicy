// Grant "Management Group Contributor" at Tenant Root to AzurePolicy UAMI

module "cisanetmg" {
  source = "./Modules/azurerm_management_group"

  name                = "cisanetmg"
  display_name        = "cisanetmg"

  subscription_ids = [module.sub1.id]
}

module "devmg" {
  source = "./Modules/azurerm_management_group"

  name                = "devmg"
  display_name        = "devmg"
  parent_management_group_id = module.cisanetmg.id
}

module "prodmg" {
  source = "./Modules/azurerm_management_group"

  name                = "prodmg"
  display_name        = "prodmg"
  parent_management_group_id = module.cisanetmg.id
}

module "csd" {
  source = "./Modules/azurerm_management_group"

  name                = "csd"
  display_name        = "csd"
  parent_management_group_id = module.cisanetmg.id
}

module "cb" {
  source = "./Modules/azurerm_management_group"

  name                = "cb"
  display_name        = "cb"
  parent_management_group_id = module.csd.id
}

module "me" {
  source = "./Modules/azurerm_management_group"

  name                = "me"
  display_name        = "me"
  parent_management_group_id = module.csd.id
}

module "th" {
  source = "./Modules/azurerm_management_group"

  name                = "th"
  display_name        = "th"
  parent_management_group_id = module.csd.id
}

module "vm" {
  source = "./Modules/azurerm_management_group"

  name                = "vm"
  display_name        = "vm"
  parent_management_group_id = module.csd.id
}

module "test1" {
  source = "./Modules/azurerm_role_definition"

  assignable_scopes = [module.cisanetmg.id]
  description = "This is a custom role created via Terraform"
  name = "my-custom-role2"
  permissions = [{
    actions     = ["*"]
    not_actions = []
  }]
  scope = "/providers/Microsoft.Management/managementGroups/cisanetmg"
}

module "sub1" {
  source = "./Modules/azurerm_subscription"

  alias = "56c86b74-e91b-4093-8c90-6220563357c3"
  subscription_name = "russellanderson.net"
  subscription_id   = "56c86b74-e91b-4093-8c90-6220563357c3"
}



///////////////////////////////////////////////////

module "mg1" {
  source = "./Modules/azurerm_management_group"

  name                = "mg1"
  display_name        = "mg1"
}

module "mg1a" {
  source = "./Modules/azurerm_management_group"

  name                = "mg1a"
  display_name        = "mg1a"
  parent_management_group_id = module.mg1.id

  subscription_ids = [
    "070cfebd-3e63-42a5-ba50-58de1db7496e"
  ]
}

module "policy1" {
  source = "./Modules/azurerm_policy_definition"

  name                = "accTestPolicy"
  display_name        = "acceptance test policy definition"
  management_group_id = module.mg1.id
  mode                = "Indexed"
  policy_type         = "Custom"

  file_path = "./Policies/Network/1.json"
}

resource "azurerm_policy_set_definition" "DNS" {
  name         = "PrivateDNSRegistration"
  policy_type  = "Custom"
  display_name = "Private Endpoint DNS Registration with Private DNS Zones"

  parameters = <<PARAMETERS
    {
        "allowedLocations": {
            "type": "Array",
            "metadata": {
                "description": "The list of allowed locations for resources.",
                "displayName": "Allowed locations",
                "strongType": "location"
            }
        }
    }
PARAMETERS

  policy_definition_reference {
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/e765b5de-1225-4ba3-bd56-1ac6695af988"
    parameter_values     = <<VALUE
    {
      "listOfAllowedLocations": {"value": "[parameters('allowedLocations')]"}
    }
    VALUE
  }
}









resource "azurerm_role_definition" "example" {
  name        = "my-custom-role"
  scope       = module.mg1a.id
  description = "This is a custom role created via Terraform"

  permissions {
    actions     = ["*"]
    not_actions = []
  }


  assignable_scopes = [
    module.mg1a.id
  ]
}