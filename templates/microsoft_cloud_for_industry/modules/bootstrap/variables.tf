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

variable "default_postfix" {
  type        = string
  default     = ""
  description = "The deployment postfix for Azure resources. (e.g 'dev')"
  validation {
    condition     = length(var.default_postfix) >= 0 && length(var.default_postfix) <= 5
    error_message = "The prefix must be between 0 and 5 characters long."
  }
}

variable "root_parent_management_group_id" {
  type        = string
  default     = ""
  description = "(Optional) parent for Management Group hierarchy, used as intermediate root Management Group parent, if specified. If empty (default) will deploy beneath Tenant Root Management Group. (e.g 'mcfs' or 'fsi)|azure_name"
}

variable "subscription_billing_scope" {
  type        = string
  description = "The subscription billing scope. (e.g '/providers/Microsoft.Billing/billingAccounts/1234567/enrollmentAccounts/123456')"
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
    id          = string
    displayName = string
  }))
  default     = {}
  description = <<DESCRIPTION
A map of Management Groups to create under the landing zone Management Group. The key of the map is the name of the Management Group. The value of the map is an object with the following attributes:

- `id` - (Required) The id of the Management Group.
- `displayName` - (Required) The display name of the Management Group.
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

variable "management_group_top_level_display_name" {
  type        = string
  description = "The display name of the top-level Management Group. (e.g 'Sovereign Landing Zone' or 'FSI Landing Zone')"
}
