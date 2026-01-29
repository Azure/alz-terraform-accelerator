variable "root_parent_management_group_id" {
  description = "The parent management group for testing"
  type        = string
  default     = ""
}

variable "subscription_ids" {
  description = "The list of subscription IDs to deploy the Platform Landing Zones into"
  type        = map(string)
  default     = {}
  nullable    = false
  validation {
    condition     = length(var.subscription_ids) == 0 || alltrue([for id in values(var.subscription_ids) : can(regex("^([0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12})$", id))])
    error_message = "All subscription IDs must be valid GUIDs"
  }
  validation {
    condition     = length(var.subscription_ids) == 0 || alltrue([for id in keys(var.subscription_ids) : contains(["management", "connectivity", "identity", "security"], id)])
    error_message = "The keys of the subscription_ids map must be one of 'management', 'connectivity', 'identity' or 'security'"
  }
}

variable "resource_name_suffix" {
  type        = string
  description = "This is the third test variable"
  default     = "e2e"
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
