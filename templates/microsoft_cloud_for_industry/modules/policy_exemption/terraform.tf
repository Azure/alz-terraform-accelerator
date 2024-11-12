// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.
/*
SUMMARY : Provider configuration for creating policy exemptions
AUTHOR/S: Cloud for Industry
*/
terraform {
  required_version = "~> 1.9"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.107"
    }
  }
}
