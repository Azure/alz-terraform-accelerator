terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.61.0"
    }
  }
  backend "azurerm" { }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}