// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.
/*
SUMMARY : Variables for deploying the dashboard
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

variable "enable_telemetry" {
  type        = bool
  default     = true
  description = <<DESCRIPTION
This variable controls whether or not telemetry is enabled for the module.
For more information see <https://aka.ms/avm/telemetryinfo>.
If it is set to false, then no telemetry will be collected.
DESCRIPTION
}

variable "customer" {
  type        = string
  default     = "Country/Region"
  description = "The name of the organization deploying the Landing Zone to brand the compliance dashboard appropriately. (e.g 'Country/Region')"
}

variable "subscription_id_management" {
  type        = string
  default     = ""
  description = "The identifier of the Management Subscription. (e.g '00000000-0000-0000-0000-000000000000')"
}

variable "dashboard_name" {
  type        = string
  description = "The name of the dashboard. (e.g 'sovereign-landing-zone-dashboard' or 'financial-services-industry-dashboard')"
}

variable "tags" {
  type        = map(string)
  default     = null
  description = "(Optional) Tags that will be assigned to subscription and resources created by this deployment script."
}
