// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.
/*
SUMMARY : Outputs for the Sovereign Landing Zone Depoloyment
AUTHOR/S: Cloud for Sovereignty
*/
output "subscription_id_management" {
  description = "The identifier of the Management Subscription."
  value       = local.subscription_id_management
}

output "subscription_id_connectivity" {
  description = "The identifier of the Connectivity Subscription."
  value       = local.subscription_id_connectivity
}

output "subscription_id_identity" {
  description = "The identifier of the Identity Subscription."
  value       = local.subscription_id_identity
}

output "management_group_info" {
  description = "The management group information with a link to management group's azure portal."
  value       = local.management_group_info
}

output "dashboard_info" {
  description = "The dashboard information with a link to portal dashboard."
  value       = local.dashboard_info
}