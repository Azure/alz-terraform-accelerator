// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.
/*
SUMMARY : Outputs for the Cloud for Financial Services
AUTHOR/S: Cloud for Financial Services
*/
output "management_group_info" {
  description = "The management group information with a link to management group's azure portal."
  value       = var.deploy_bootstrap ? module.bootstrap[0].management_group_info : null
}

output "dashboard_info" {
  description = "The dashboard information with a link to portal dashboard."
  value       = var.deploy_dashboard ? module.dashboard[0].dashboard_info : null
}

output "resource_ids" {
  description = "The resource identifiers for updating policy assignments."
  value = var.deploy_platform ? {
    log_analytics_workspace = module.platform[0].log_analytics_workspace_id
    ddos_protection_plan    = module.platform[0].ddos_protection_plan_id
  } : null
}

output "subscription_ids" {
  description = "The identifiers of the subscriptions."
  value = {
    management   = var.subscription_id_management
    connectivity = var.subscription_id_connectivity
    identity     = var.subscription_id_identity
  }
}
