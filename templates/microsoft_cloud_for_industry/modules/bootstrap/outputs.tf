// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.
/*
SUMMARY : Outputs for bootstrap
AUTHOR/S: Cloud for Industry
*/
output "policy_assignment_resource_ids" {
  description = "The list of policy assignment resource ids."
  value       = module.management_groups.policy_assignment_resource_ids
}

output "management_group_info" {
  description = "The management group information with a link to management group's azure portal."
  value       = local.management_group_info
}
