// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.
/*
SUMMARY : This file contains the data block to get the tenant id
AUTHOR/S: Cloud for Sovereignty
*/
# This allows us to get the tenant id
data "azurerm_client_config" "current" {}
