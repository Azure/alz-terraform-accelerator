// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.
/*
SUMMARY : This file contains the data blocks for the azapi remediation resources
AUTHOR/S: Cloud for Industry
*/
data "alz_metadata" "metadata" {}

data "azapi_resource" "built_in_policy_set_definitions" {
  for_each               = local.policy_assignment_name_to_built_in_policy_definition_ids
  resource_id            = each.value
  type                   = "Microsoft.Authorization/policySetDefinitions@2025-01-01"
  response_export_values = ["*"]
}
