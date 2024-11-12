// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.
/*
SUMMARY : Outputs for the Cloud for Financial Services
AUTHOR/S: Cloud for Financial Services
*/
output "management_group_info" {
  description = "The management group information with a link to management group's azure portal."
  value       = module.bootstrap.management_group_info
}

output "dashboard_info" {
  description = "The dashboard information with a link to portal dashboard."
  value       = module.dashboard.dashboard_info
}

output "resource_ids" {
  description = "The resource identifiers for updating policy assignments."
  value = {
    log_analytics_workspace = module.platform.log_analytics_workspace_id
    ddos_protection_plan    = module.platform.ddos_protection_plan_id
  }
}

output "subscription_ids" {
  description = "The identifiers of the subscriptions."
  value = {
    management   = local.subscription_id_management
    connectivity = local.subscription_id_connectivity
    identity     = local.subscription_id_identity
  }
}
