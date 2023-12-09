terraform {
  required_version = ">= 1.6"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.61"
    }
    azapi = {
      source  = "azure/azapi"
      version = "~> 1.10.0"
    }
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = "~> 0.10"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
}

provider "azurerm" {
  subscription_id = var.azure_subscription_id == "" ? null : var.azure_subscription_id
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

