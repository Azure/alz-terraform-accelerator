// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.
/*
SUMMARY : Outputs for platform
AUTHOR/S: Cloud for Industry
*/
output "log_analytics_workspace_id" {
  description = "The resource identifier of the log analytics workspace id."
  value       = local.log_analytics_workspace_id
}

output "ddos_protection_plan_id" {
  description = "The resource identifier of the DDoS protection plan."
  value       = local.ddos_protection_plan_id
}
