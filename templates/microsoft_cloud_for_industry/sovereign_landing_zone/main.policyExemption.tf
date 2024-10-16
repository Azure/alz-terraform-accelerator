// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.
/*
SUMMARY : Creates policy exemptions for the Sovereign Landing Zone
AUTHOR/S: Cloud for Sovereignty
*/
resource "azurerm_management_group_policy_exemption" "policy_exemptions" {
  for_each = local.policy_exemptions

  name                            = each.value.name
  display_name                    = each.value.display_name
  description                     = each.value.description
  management_group_id             = each.value.management_group_id
  policy_assignment_id            = each.value.policy_assignment_id
  policy_definition_reference_ids = each.value.policy_definition_reference_ids
  exemption_category              = each.value.exemption_category

  depends_on = [module.slz_management_groups, azurerm_management_group_policy_assignment.custom_policy]
}
