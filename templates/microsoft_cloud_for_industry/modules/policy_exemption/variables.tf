// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.
/*
SUMMARY : Variables for creating policy exemptions
AUTHOR/S: Cloud for Industry
*/
variable "policy_exemptions" {
  type = map(object({
    name                            = string
    display_name                    = string
    description                     = string
    management_group_id             = string
    policy_assignment_id            = string
    policy_definition_reference_ids = optional(list(string))
    exemption_category              = optional(string, "Mitigated")
  }))
  default     = {}
  description = <<DESCRIPTION
A map of policy exemptions to create. The key of the map is the name of the policy exemption. The value of the map is an object with the following attributes:

- `name` - (Required) The name of the policy exemption.
- `display_name` - (Required) The display name of the policy exemption.
- `description` - (Required) The description of the policy exemption.
- `management_group_id` - (Required) The management group id of the policy exemption.
- `policy_assignment_id` - (Required) The policy assignment id of the policy exemption.
- `policy_definition_reference_ids` - (Optional) The policy definition reference ids of the policy exemption. Defaults to `null`.
- `exemption_category` - (Optional) The exemption category of the policy exemption. Defaults to `Mitigated`.
DESCRIPTION
}
