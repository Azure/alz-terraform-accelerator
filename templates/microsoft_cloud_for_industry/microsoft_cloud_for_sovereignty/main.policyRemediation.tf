// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.
/*
SUMMARY : Creates policy remediations for the Sovereign Landing Zone
AUTHOR/S: Cloud for Sovereignty
*/
resource "azurerm_management_group_policy_remediation" "policy_remediation" {
  for_each             = { for k, v in local.policy_assignment_resource_ids : k => v if !contains(local.policy_set_definition_name, lower(split("/", k)[1])) }
  name                 = substr(lower(split("/", each.key)[1]), 0, 64)
  management_group_id  = join("/", slice(split("/", each.value), 0, 5))
  policy_assignment_id = each.value

  depends_on = [module.slz_management_groups, azurerm_management_group_policy_assignment.custom_policy, azurerm_management_group_policy_exemption.policy_exemptions]
}