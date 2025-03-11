// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.
/*
SUMMARY : This file contains the providers for the Cloud for Financial Services
AUTHOR/S: Cloud for Financial Services
*/
terraform {
  required_version = "~> 1.9"
  required_providers {
    alz = {
      source  = "azure/alz"
      version = "~> 0.17"
    }

    azapi = {
      source  = "azure/azapi"
      version = "~> 2.2"
    }

    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.107"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.6.3"
    }
  }
  # backend "azurerm" {}
}

# Include the additional policies and override archetypes
provider "alz" {
  library_overwrite_enabled = true
  library_references = [
    {
      path = "platform/fsi"
      ref  = "2025.03.0"
    },
    {
      custom_url = "${path.root}/lib"
    }
  ]
}

provider "azurerm" {
  features {}
}


provider "azurerm" {
  alias           = "management"
  subscription_id = var.subscription_id_management
  features {}
}

provider "azurerm" {
  alias           = "connectivity"
  subscription_id = var.subscription_id_connectivity
  features {}
}

provider "azurerm" {
  alias           = "identity"
  subscription_id = var.subscription_id_identity
  features {}
}

provider "azapi" {
  disable_default_output = true
}
