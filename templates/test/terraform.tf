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
  subscription_id            = var.subscription_ids["management"]
  features {}
}

provider "azurerm" {
  skip_provider_registration = true
  alias                      = "connectivity"
  subscription_id            = var.subscription_ids["connectivity"]
  features {}
}

provider "azurerm" {
  skip_provider_registration = true
  alias                      = "identity"
  subscription_id            = var.subscription_ids["identity"]
  features {}
}

provider "azurerm" {
  skip_provider_registration = true
  alias                      = "security"
  subscription_id            = var.subscription_ids["security"]
  features {}
}

provider "azapi" {
  skip_provider_registration = true
}
