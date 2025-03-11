// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.
/*
SUMMARY : Common module for creating policy exemptions
AUTHOR/S: Cloud for Industry
*/
resource "azapi_resource" "policy_exemptions" {
  for_each = var.policy_exemptions

  type = "Microsoft.Authorization/policyExemptions@2022-07-01-preview"
  body = {
    properties = {
      policyAssignmentId = each.value.policy_assignment_id
      description        = each.value.description
      displayName        = each.value.display_name
      exemptionCategory  = each.value.exemption_category
    }
  }
  name      = each.value.name
  parent_id = each.value.management_group_id
  retry     = local.retry

  timeouts {
    create = local.timeouts.create
    delete = local.timeouts.delete
    update = local.timeouts.update
    read   = local.timeouts.read
  }
}
