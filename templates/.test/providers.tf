terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.61.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.5.1"
    }
  }
  # backend "azurerm" {}
}

provider "azurerm" {
  features {}
}
