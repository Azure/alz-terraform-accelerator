terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.61"
    }
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = "~> 0.9"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

provider "azuredevops" {
  personal_access_token = var.version_control_system_access_token
  org_service_url       = module.azure_devops.organization_url
}

