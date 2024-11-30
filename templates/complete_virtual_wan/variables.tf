variable "default_location" {
  type        = string
  description = "The location for Azure resources. (e.g 'uksouth')|1|azure_location"
}

variable "subscription_id_connectivity" {
  type        = string
  description = "value of the subscription id for the Connectivity subscription|5|azure_subscription_id"
}

variable "subscription_id_identity" {
  type        = string
  description = "value of the subscription id for the Identity subscription|6|azure_subscription_id"
}

variable "subscription_id_management" {
  type        = string
  description = "value of the subscription id for the Management subscription|4|azure_subscription_id"
}

variable "configuration_file_path" {
  type        = string
  default     = ""
  description = "The path of the configuration file|7|configuration_file_path"
}

variable "default_postfix" {
  type        = string
  default     = "landing-zone"
  description = "The default postfix for Azure resources. (e.g 'landing-zone')|2|azure_name"
}

variable "root_parent_management_group_id" {
  type        = string
  default     = ""
  description = "This is the id of the management group that the ALZ hierarchy will be nested under, will default to the Tenant Root Group|3|azure_name"
}
