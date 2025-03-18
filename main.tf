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