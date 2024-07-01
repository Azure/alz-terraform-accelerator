terraform {
  required_version = "~> 1.8"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.107"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "~> 1.13"
    }
  }
  # backend "azurerm" {}
}

provider "azapi" {
  skip_provider_registration = true
  subscription_id            = var.subscription_id_management
}

provider "azurerm" {
  skip_provider_registration = true
  features {}
}

provider "azurerm" {
  alias                      = "management"
  subscription_id            = var.subscription_id_management
  skip_provider_registration = true
  features {}
}

provider "azurerm" {
  alias                      = "connectivity"
  subscription_id            = var.subscription_id_connectivity
  skip_provider_registration = true
  features {}
}
