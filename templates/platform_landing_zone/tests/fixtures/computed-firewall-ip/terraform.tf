terraform {
  required_version = "~> 1.12"
  required_providers {
    alz = {
      source = "Azure/alz"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "2.12.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.81.0"
    }
    modtm = {
      source = "Azure/modtm"
    }
    local = {
      source = "hashicorp/local"
    }
  }
}
