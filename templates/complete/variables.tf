variable "starter_locations" {
  type        = list(string)
  description = "The location for Azure resources. (e.g 'uksouth')|azure_location"
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

variable "configuration_file_path" {
  type        = string
  default     = ""
  description = "The path of the configuration file|configuration_file_path"
}

variable "default_postfix" {
  type        = string
  default     = "landing-zone"
  description = "The default postfix for Azure resources. (e.g 'landing-zone')|azure_name"
}

variable "root_parent_management_group_id" {
  type        = string
  default     = ""
  description = "This is the id of the management group that the ALZ hierarchy will be nested under, will default to the Tenant Root Group|azure_name"
}
