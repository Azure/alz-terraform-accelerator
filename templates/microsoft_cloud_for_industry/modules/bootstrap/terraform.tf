// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.
/*
SUMMARY : Provider configuration for deploying bootstrap
AUTHOR/S: Cloud for Industry
*/

terraform {
  required_version = "~> 1.9"
  required_providers {
    alz = {
      source  = "azure/alz"
      version = ">= 0.15.1"
    }

    azapi = {
      source  = "azure/azapi"
      version = ">= 2.0.0-beta"
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
}
