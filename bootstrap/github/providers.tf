terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.61"
    }
    github = {
      source  = "integrations/github"
      version = "~> 5.36"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
}

provider "azurerm" {
  subscription_id = coalesce(var.azure_subscription_id, data.azurerm_client_config.current.subscription_id)
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

provider "github" {
  token = var.version_control_system_access_token
  owner = var.version_control_system_organization
}
