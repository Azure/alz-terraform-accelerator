// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.
/*
SUMMARY : Deploys the policies for the Sovereign Landing Zone
AUTHOR/S: Cloud for Sovereignty
*/
resource "azurerm_management_group_policy_assignment" "custom_policy" {
  for_each = local.customer_policy_sets

  name                 = substr(each.value.policySetAssignmentName, 0, 24)
  management_group_id  = each.value.policySetManagementGroupAssignmentScope
  policy_definition_id = each.value.policySetDefinitionId
  display_name         = each.value.policySetAssignmentDisplayName
  description          = each.value.policySetAssignmentDescription
  parameters           = each.value.policyAssignmentParameters
  enforce              = lower(var.policy_assignment_enforcement_mode) == "default" ? true : false
  identity {
    type = "SystemAssigned"
  }
  location = local.default_location

  depends_on = [module.slz_management_groups]
}
