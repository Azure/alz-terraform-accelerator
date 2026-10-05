terraform {
  required_providers {
    alz = {
      source  = "Azure/alz"
      version = "~> 0.21"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
      configuration_aliases = [
        azurerm.management,
        azurerm.connectivity,
      ]
    }
    azapi = {
      source  = "Azure/azapi"
      version = "~> 2.0"
      configuration_aliases = [
        azapi.connectivity,
      ]
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.10"
    }
  }
}
