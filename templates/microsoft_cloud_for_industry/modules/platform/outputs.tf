// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.
/*
SUMMARY : Outputs for platform
AUTHOR/S: Cloud for Industry
*/
output "log_analytics_workspace_id" {
  description = "The resource identifier of the log analytics workspace id."
  value       = var.deploy_log_analytics_workspace ? module.alz_management[0].log_analytics_workspace.id : null
}

output "ddos_protection_plan_id" {
  description = "The resource identifier of the DDoS protection plan."
  value       = var.deploy_hub_network && var.deploy_ddos_protection ? module.ddos_protection_plan[0].resource.id : null
}
