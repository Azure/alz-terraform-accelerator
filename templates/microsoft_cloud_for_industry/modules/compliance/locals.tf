// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.
/*
SUMMARY : Local variables for custom compliance policies
AUTHOR/S: Cloud for Industry
*/
locals {
  customer_policy_sets = { for k, v in var.customer_policy_sets : k => {
    policySetDefinitionId                   = v.policySetDefinitionId
    policySetAssignmentName                 = v.policySetAssignmentName
    policySetAssignmentDisplayName          = v.policySetAssignmentDisplayName
    policySetAssignmentDescription          = v.policySetAssignmentDescription
    policySetManagementGroupAssignmentScope = v.policySetManagementGroupAssignmentScope
    policyAssignmentParameters              = v.policyParameterFilePath == "" ? "" : file(v.policyParameterFilePath)
    }
  }
}