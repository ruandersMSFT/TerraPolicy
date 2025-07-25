terraform {
  required_providers {
    azapi = {
      source  = "azure/azapi"
      version = "2.3.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.36.0"
    }
  }

  backend "azurerm" {
    storage_account_name = "ruanderspolicy"
    container_name = "policy"
    key = "terraform.tfstate"
  }
}

provider "azurerm" {
  resource_provider_registrations = "none" # This is only required when the User, Service Principal, or Identity running Terraform lacks the permissions to register Azure Resource Providers.
  features {}
  subscription_id = "070cfebd-3e63-42a5-ba50-58de1db7496e"
}