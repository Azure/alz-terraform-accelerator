variable "root_parent_management_group_id" {
  description = "The parent management group for testing"
  type        = string
  default     = ""
}

variable "subscription_id_connectivity" {
  description = "The identifier of the Connectivity Subscription. (e.g '00000000-0000-0000-0000-000000000000')|azure_subscription_id"
  type        = string
}

variable "subscription_id_identity" {
  description = "The identifier of the Identity Subscription. (e.g '00000000-0000-0000-0000-000000000000')|azure_subscription_id"
  type        = string
}

variable "subscription_id_management" {
  description = "The identifier of the Management Subscription. (e.g 00000000-0000-0000-0000-000000000000)|azure_subscription_id"
  type        = string
}

variable "child_management_group_display_name" {
  description = "The child management group for testing display name"
  type        = string
  default     = "E2E Test"
}

variable "starter_locations" {
  type        = list(string)
  description = "This is the fourth test variable|azure_location"
}

variable "boolean_test" {
  type        = bool
  description = "This is the fifth test variable"
  default     = true
}
