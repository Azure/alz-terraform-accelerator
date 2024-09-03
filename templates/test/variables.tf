variable "root_parent_management_group_id" {
  description = "The parent management group for testing|1"
  type        = string
  default     = ""
}

variable "subscription_id_connectivity" {
  description = "The identifier of the Connectivity Subscription. (e.g '00000000-0000-0000-0000-000000000000')|2|azure_subscription_id"
  type        = string
}

variable "subscription_id_identity" {
  description = "The identifier of the Identity Subscription. (e.g '00000000-0000-0000-0000-000000000000')|3|azure_subscription_id"
  type        = string
}

variable "subscription_id_management" {
  description = "The identifier of the Management Subscription. (e.g 00000000-0000-0000-0000-000000000000)|4|azure_subscription_id"
  type        = string
}

variable "child_management_group_display_name" {
  description = "The child management group for testing display name|5"
  type        = string
  default     = "E2E Test"
}

variable "starter_location" {
  type        = string
  description = "This is the fourth test variable|6|azure_location"
  default     = "uksouth"
}
