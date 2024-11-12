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

output "subscription_id_management" {
  description = "The identifier of the Management Subscription."
  value       = var.subscription_id_management != "" ? var.subscription_id_management : module.subscription_management_creation[0].subscription_id
}

output "subscription_id_connectivity" {
  description = "The identifier of the Connectivity Subscription."
  value       = var.subscription_id_connectivity != "" ? var.subscription_id_connectivity : module.subscription_connectivity_creation[0].subscription_id
}

output "subscription_id_identity" {
  description = "The identifier of the Identity Subscription."
  value       = var.subscription_id_identity != "" ? var.subscription_id_identity : module.subscription_identity_creation[0].subscription_id
}

output "management_group_info" {
  description = "The management group information with a link to management group's azure portal."
  value       = local.management_group_info
}