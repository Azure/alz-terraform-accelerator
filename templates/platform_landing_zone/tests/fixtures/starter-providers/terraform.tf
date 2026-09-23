terraform {
  required_providers {
    alz = {
      source = "Azure/alz"
    }
    azapi = {
      source                = "Azure/azapi"
      configuration_aliases = [azapi.connectivity]
    }
    azurerm = {
      source                = "hashicorp/azurerm"
      configuration_aliases = [azurerm.connectivity, azurerm.management]
    }
    local = {
      source = "hashicorp/local"
    }
  }
}
