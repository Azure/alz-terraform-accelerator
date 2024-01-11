terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.61.0"
    }
    azapi = {
      source  = "azure/azapi"
      version = ">= 1.10.0"
    }
    http = {
      source  = "hashicorp/http"
      version = ">= 3.4.1"
    }
  }
}
