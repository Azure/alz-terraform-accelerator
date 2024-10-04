terraform {
  required_version = "~> 1.9"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.107"
      configuration_aliases = [
        azurerm.connectivity,
        azurerm.management,
      ]
    }
    azapi = {
      source  = "Azure/azapi"
      version = "~> 1.13"
    }
  }
  # backend "azurerm" {}
}
