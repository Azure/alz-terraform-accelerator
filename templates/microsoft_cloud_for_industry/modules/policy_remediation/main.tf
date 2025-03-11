// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.
/*
SUMMARY : Common module for creating policy remediations
AUTHOR/S: Cloud for Industry
*/
resource "azapi_resource" "policy_remediation_policy_definitions" {
  for_each  = var.policy_assignment_name_to_policy_assignment_resource_ids
  type      = "Microsoft.PolicyInsights/remediations@2024-10-01"
  name      = substr(lower(split("/", each.key)[1]), 0, 64)
  parent_id = join("/", slice(split("/", each.value), 0, 5))
  body = {
    properties = {
      policyAssignmentId = each.value
      failureThreshold = {
        percentage = 1
      }
    }
  }
  ignore_casing = true
  retry         = local.retry

  timeouts {
    create = local.timeouts.create
    delete = local.timeouts.delete
    update = local.timeouts.update
    read   = local.timeouts.read
  }
}

resource "azapi_resource" "policy_remediation_policy_set_definitions" {
  count     = length(var.policy_assignment_ids_with_reference_id)
  type      = "Microsoft.PolicyInsights/remediations@2024-10-01"
  name      = replace(split("policyAssignments/", var.policy_assignment_ids_with_reference_id[count.index])[1], "/", "-")
  parent_id = join("/", slice(split("/", split(":", var.policy_assignment_ids_with_reference_id[count.index])[0]), 0, 5))
  body = {
    properties = {
      policyAssignmentId          = split(":", var.policy_assignment_ids_with_reference_id[count.index])[0]
      policyDefinitionReferenceId = split(":", var.policy_assignment_ids_with_reference_id[count.index])[1]
      failureThreshold = {
        percentage = 1
      }
    }
  }
  ignore_casing = true
  retry         = local.retry

  timeouts {
    create = local.timeouts.create
    delete = local.timeouts.delete
    update = local.timeouts.update
    read   = local.timeouts.read
  }
}
