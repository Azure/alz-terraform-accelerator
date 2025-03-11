// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.
/*
SUMMARY : Variables for the Management Groups and Subscriptions for the Landing Zone
AUTHOR/S: Cloud for Industry
*/
variable "location" {
  type        = string
  description = "Location used for deploying Azure resources. (e.g 'uksouth')|azure_location"
}

variable "default_prefix" {
  type        = string
  description = "Prefix added to all Azure resources created by the Landing Zone. (e.g 'mcfs' or 'fsi')"
  validation {
    condition     = length(var.default_prefix) >= 2 && length(var.default_prefix) <= 5
    error_message = "The prefix must be between 2 and 5 characters long."
  }
}

variable "optional_postfix" {
  type        = string
  default     = ""
  description = "The deployment postfix for Azure resources. (e.g 'dev')"
  validation {
    condition     = length(var.optional_postfix) >= 0 && length(var.optional_postfix) <= 5
    error_message = "The prefix must be between 0 and 5 characters long."
  }
}

variable "root_parent_management_group_id" {
  type        = string
  default     = ""
  description = "(Optional) parent for Management Group hierarchy, used as intermediate root Management Group parent, if specified. If empty (default) will deploy beneath Tenant Root Management Group. (e.g 'mcfs' or 'fsi)|azure_name"
}

variable "architecture_name" {
  type        = string
  description = "Name of the architecture definition. (e.g 'slz' or 'fsi)"
}

variable "enable_telemetry" {
  type        = bool
  default     = true
  description = <<DESCRIPTION
This variable controls whether or not telemetry is enabled for the module.
For more information see https://aka.ms/avm/telemetryinfo.
If it is set to false, then no telemetry will be collected.
DESCRIPTION
  nullable    = false
}

variable "landing_zone_management_group_children" {
  type = map(object({
    id              = string
    display_name    = string
    archetypes      = optional(set(string), [])
    subscription_id = optional(string, "")
  }))
  default     = {}
  description = <<DESCRIPTION
Optional map of Management Groups to create under the landing zone Management Group. The key of the map is the name of the Management Group. The value of the map is an object with the following attributes:

- `id` - (Required) The id of the Management Group.
- `display_name` - (Required) The display name of the Management Group.
- `archetypes` - (Optional) The set of archetypes to apply to the Management Group.
- `subscription_id` - (Optional) The subscription ID to move into the Management Group.
DESCRIPTION
}

variable "platform_management_group_children" {
  type = map(object({
    id              = string
    display_name    = string
    archetypes      = optional(set(string), [])
    subscription_id = optional(string, "")
  }))
  default     = {}
  description = <<DESCRIPTION
Optional map of Management Groups to create under the platform Management Group. The key of the map is the name of the Management Group. The value of the map is an object with the following attributes:

- `id` - (Required) The id of the Management Group.
- `display_name` - (Required) The display name of the Management Group.
- `archetypes` - (Optional) The set of archetypes to apply to the Management Group.
- `subscription_id` - (Optional) The subscription ID to move into the Management Group.
DESCRIPTION
}

variable "subscription_id_connectivity" {
  type        = string
  default     = ""
  description = "The identifier of the Connectivity Subscription. (e.g '00000000-0000-0000-0000-000000000000')"
}

variable "subscription_id_identity" {
  type        = string
  default     = ""
  description = "The identifier of the Identity Subscription. (e.g '00000000-0000-0000-0000-000000000000')"
}

variable "subscription_id_management" {
  type        = string
  default     = ""
  description = "The identifier of the Management Subscription. (e.g '00000000-0000-0000-0000-000000000000')"
}

variable "connectivity_management_group_id" {
  type        = string
  description = "The connectivity Management Group ID."
}

variable "identity_management_group_id" {
  type        = string
  description = "The identity Management Group ID."
}

variable "management_management_group_id" {
  type        = string
  description = "The management Management Group ID."
}

variable "policy_default_values" {
  type        = map(string)
  default     = null
  description = <<DESCRIPTION
  A map of default values to apply to policy assignments. The key is the default name as defined in the library, and the value is an JSON object containing a single `value` attribute with the values to apply. This to mitigate issues with the Terraform type system. E.g. `{ defaultName = jsonencode({ value = \"value\"}) }`
  DESCRIPTION
}

variable "partner_id_uuid" {
  type        = string
  description = "The partner id UUID. (e.g '00000000-0000-0000-0000-000000000000')"
}

variable "tenant_id" {
  type        = string
  description = "The Azure tenant identifier."
}

variable "top_level_management_group_name" {
  type        = string
  description = "The display name of the top-level Management Group. (e.g 'Sovereign Landing Zone' or 'FSI Landing Zone')"
}

variable "default_security_groups" {
  type        = set(string)
  description = "Array of default security groups. Default to be empty."
  validation {
    condition = alltrue([
      for sg in var.default_security_groups : contains(local.allowed_security_group_list, sg)
    ])
    error_message = "The allowed security groups are \"Owner\", \"Reader\", \"Contributor\"."
  }
}

variable "default_policy_exemptions" {
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

variable "log_analytics_workspace_resource_id" {
  type        = string
  description = "The resource ID of the Log Analytics workspace to use for the deployment. (e.g '/subscriptions/00000000-0000-0000-0000-000000000000/resourcegroups/placeholder/providers/Microsoft.OperationalInsights/workspaces/placeholder-la')"
}
