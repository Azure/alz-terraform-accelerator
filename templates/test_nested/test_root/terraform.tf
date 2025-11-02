terraform {
  required_version = "~> 1.12"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.107"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "~> 1.13"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
  # backend "azurerm" {}
}

provider "azurerm" {
  resource_provider_registrations = "none"
  features {}
}

provider "azurerm" {
  resource_provider_registrations = "none"
  alias                           = "management"
  subscription_id                 = var.subscription_ids["management"]
  features {}
}

provider "azurerm" {
  resource_provider_registrations = "none"
  alias                           = "connectivity"
  subscription_id                 = var.subscription_ids["connectivity"]
  features {}
}

provider "azurerm" {
  resource_provider_registrations = "none"
  alias                           = "identity"
  subscription_id                 = var.subscription_ids["identity"]
  features {}
}

provider "azurerm" {
  resource_provider_registrations = "none"
  alias                           = "security"
  subscription_id                 = var.subscription_ids["security"]
  features {}
}

provider "azapi" {
  resource_provider_registrations = "none"
}
