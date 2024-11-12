// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.
/*
SUMMARY : Common module for creating policy remediations
AUTHOR/S: Cloud for Industry
*/
resource "azurerm_management_group_policy_remediation" "policy_remediation" {
  for_each             = { for k, v in var.policy_assignment_resource_ids : k => v if !contains(var.policy_set_definition_name_exclusions, lower(split("/", k)[1])) }
  name                 = substr(lower(split("/", each.key)[1]), 0, 64)
  management_group_id  = join("/", slice(split("/", each.value), 0, 5))
  policy_assignment_id = each.value
}
