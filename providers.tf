terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.61.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.30.0"
    }
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = ">=0.8.0"
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

provider "azuread" {
}

locals {
  azure_devops_url = var.azure_devops_use_organisation_legacy_url ? "https://dev.azure.com/${var.version_control_system_organization}" : "https://${var.version_control_system_organization}.visualstudio.com"
}

provider "azuredevops" {
  personal_access_token = var.version_control_system_access_token
  org_service_url       = local.azure_devops_url
}

provider "github" {
  token = var.version_control_system_access_token
  owner = var.version_control_system_organization
}