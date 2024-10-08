variable "starter_locations" {
  type        = list(string)
  description = "The default for Azure resources. (e.g 'uksouth')|azure_location"
}

variable "subscription_id_connectivity" {
  type        = string
  description = "value of the subscription id for the Connectivity subscription|azure_subscription_id"
}

variable "subscription_id_identity" {
  type        = string
  description = "value of the subscription id for the Identity subscription|azure_subscription_id"
}

variable "subscription_id_management" {
  type        = string
  description = "value of the subscription id for the Management subscription|azure_subscription_id"
}

variable "root_parent_management_group_id" {
  type        = string
  default     = ""
  description = "This is the id of the management group that the ALZ hierarchy will be nested under, will default to the Tenant Root Group|azure_name"
}

variable "enable_telemetry" {
  type        = bool
  default     = true
  description = "Flag to enable/disable telemetry"
}

variable "skip_deploy" {
  type        = bool
  default     = false
  description = "Flag to skip deployment. This is used for testing and documentation generation purposes."
}
