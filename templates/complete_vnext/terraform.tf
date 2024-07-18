terraform {
  required_version = "~> 1.6"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    alz = {
      source  = "azure/alz"
      version = "0.13.0"
    }
  }
  # backend "azurerm" {}
}

provider "alz" {
  library_references = [
    { 
      custom_url = "git::github.com/Azure/Azure-Landing-Zones-Library//platform/alz?ref=add-default-assignment-values"
    }
  ]
}

provider "azurerm" {
  features {}
}

provider "azurerm" {
  alias           = "management"
  subscription_id = var.subscription_id_management
  features {}
}

provider "azurerm" {
  alias           = "connectivity"
  subscription_id = var.subscription_id_connectivity
  features {}
}
