terraform {
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
  skip_provider_registration = true
  features {}
}

provider "azurerm" {
  skip_provider_registration = true
  alias                      = "management"
  subscription_id            = var.subscription_id_management
  features {}
}

provider "azurerm" {
  skip_provider_registration = true
  alias                      = "connectivity"
  subscription_id            = var.subscription_id_connectivity
  features {}
}

provider "azurerm" {
  skip_provider_registration = true
  alias                      = "identity"
  subscription_id            = var.subscription_id_identity
  features {}
}

provider "azapi" {
  skip_provider_registration = true
}
