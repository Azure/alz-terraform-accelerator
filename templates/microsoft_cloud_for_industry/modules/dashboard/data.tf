// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.
/*
SUMMARY : This file contains the data block to get Azure domains
AUTHOR/S: Cloud for Industry
*/
data "azuread_domains" "default" {
  only_initial = true
}