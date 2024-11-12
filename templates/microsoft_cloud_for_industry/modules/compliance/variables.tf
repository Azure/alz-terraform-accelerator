// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.
/*
SUMMARY : Variables for creating custom compliance policies
AUTHOR/S: Cloud for Industry
*/
variable "location" {
  type        = string
  description = "Location used for deploying Azure resources. (e.g 'uksouth')|azure_location"
}

variable "customer_policy_sets" {
  type = map(object({
    policySetDefinitionId                   = string
    policySetAssignmentName                 = string
    policySetAssignmentDisplayName          = string
    policySetAssignmentDescription          = string
    policySetManagementGroupAssignmentScope = string
    policyParameterFilePath                 = optional(string, "")
  }))
  default     = {}
  description = <<DESCRIPTION
A map of policy sets to create. The key of the map is the name of the policy set. The value of the map is an object with the following attributes:

- `policySetDefinitionId` - (Required) The id of the policy set definition.
- `policySetAssignmentName` - (Required) The name of the policy set assignment.
- `policySetAssignmentDisplayName` - (Required) The display name of the policy set assignment.
- `policySetAssignmentDescription` - (Required) The description of the policy set assignment.
- `policySetManagementGroupAssignmentScope` - (Required) The management group assignment scope of the policy set assignment.
- `policyParameterFilePath` - (Optional) The path to the policy parameter file. Defaults to `""`.
DESCRIPTION
}

variable "policy_assignment_enforcement_mode" {
  type        = string
  default     = "Default"
  description = "The enforcement mode used in all policy and initiative assignments."
  validation {
    condition     = contains(["Default", "DoNotEnforce"], var.policy_assignment_enforcement_mode)
    error_message = "Allowed values are 'Default' and 'DoNotEnforce'."
  }
}