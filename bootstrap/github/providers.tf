terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.61.0"
    }
    github = {
      source  = "integrations/github"
      version = "~> 5.36"
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

provider "github" {
  token = var.version_control_system_access_token
  owner = var.version_control_system_organization
}
