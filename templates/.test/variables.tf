variable "subscription_id_connectivity" {
  description = "The identifier of the Connectivity Subscription. (e.g '00000000-0000-0000-0000-000000000000')|1|azure_subscription_id"
  type        = string
}

variable "subscription_id_identity" {
  description = "The identifier of the Identity Subscription. (e.g '00000000-0000-0000-0000-000000000000')|2|azure_subscription_id"
  type        = string
}

variable "subscription_id_management" {
  description = "The identifier of the Management Subscription. (e.g 00000000-0000-0000-0000-000000000000)|3|azure_subscription_id"
  type        = string
}

variable "parent_management_group_display_name" {
  description = "The parent management group for testing|4"
  type        = string
  default     = "Tenant Root Group"
}

variable "child_management_group_name" {
  description = "The child management group name for testing|5"
  type        = string
  default     = "testing123"
}

variable "child_management_group_display_name" {
  description = "The child management group for testing display name|6"
  type        = string
  default     = "Testing 123"
}

variable "resource_group_location" {
  type        = string
  description = "This is the fourth test variable|7|azure_location"
  default = "uksouth"
}

variable "resource_group_name" {
  description = "The name of the resource group for testing|8"
  type        = string
  default     = "testing-123"
}
