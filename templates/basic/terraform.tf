terraform {
  required_version = "~> 1.6"
  required_providers {
    azurerm = "~> 3.88"
  }
  # backend "azurerm" {}
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
