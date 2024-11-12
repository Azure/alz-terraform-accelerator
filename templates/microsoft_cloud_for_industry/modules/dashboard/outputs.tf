// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.
/*
SUMMARY : Outputs for dashboard
AUTHOR/S: Cloud for Industry
*/
output "dashboard_info" {
  description = "The dashboard information with a link to portal dashboard."
  value       = local.dashboard_info
}
