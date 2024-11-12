// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.
/*
SUMMARY : Variables for creating policy remediations
AUTHOR/S: Cloud for Industry
*/
variable "policy_assignment_resource_ids" {
  type        = map(string)
  default     = {}
  description = "A map of policy assignment names to their resource ids."
}

variable "policy_set_definition_name_exclusions" {
  type        = set(string)
  default     = []
  description = "A set of policy set definition names to exclude from remediation."
}