// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.
/*
SUMMARY : Provider configuration for creating policy remediations
AUTHOR/S: Cloud for Industry
*/
terraform {
  required_version = "~> 1.9"
  required_providers {
    azapi = {
      source  = "azure/azapi"
      version = "~> 2.2"
    }
  }
}
