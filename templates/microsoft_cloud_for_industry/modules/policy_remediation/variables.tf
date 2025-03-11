// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.
/*
SUMMARY : Variables for creating policy remediations
AUTHOR/S: Cloud for Industry
*/
variable "policy_assignment_ids_with_reference_id" {
  type        = list(string)
  default     = []
  description = "A list of policy assignment resource IDs with reference ID. (e.g /providers/Microsoft.Management/managementGroups/rootmg/providers/Microsoft.Authorization/policyAssignments/Enforce-Sovereign-Global:AllowedLocations)"
}

variable "policy_assignment_name_to_policy_assignment_resource_ids" {
  type        = map(string)
  default     = {}
  description = "Map of policy assignment name to policy assignment resource ID. (e.g rootmg/Enforce-Sovereign-Global = /providers/Microsoft.Management/managementGroups/sd117/providers/Microsoft.Authorization/policyAssignments/Enforce-Sovereign-Global)"
}
