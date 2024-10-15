// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.
/*
SUMMARY : Outputs for the Sovereign Landing Zone Depoloyment
AUTHOR/S: Cloud for Sovereignty
*/
terraform {
  required_version = "~> 1.9"
  required_providers {
    alz = {
      source  = "azure/alz"
      version = "0.15.1"
    }

    azapi = {
      source  = "azure/azapi"
      version = "2.0.0-beta"
    }

    azuread = {
      source  = "hashicorp/azuread"
      version = "2.41.0"
    }

    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.107"
    }
  }
}

# Include the additional policies and override archetypes
provider "alz" {
  library_references = [
    {
      path = "platform/slz",
      ref  = "2024.10.0"
    },
    {
      custom_url = "${path.root}/lib"
    }
  ]
}

provider "azurerm" {
  features {}
}

provider "azuread" {}

provider "azurerm" {
  alias           = "management"
  subscription_id = local.subscription_id_management
  features {}
}

provider "azurerm" {
  alias           = "connectivity"
  subscription_id = local.subscription_id_connectivity
  features {}
}

provider "azurerm" {
  alias           = "identity"
  subscription_id = local.subscription_id_identity
  features {}
}