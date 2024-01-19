variable "default_location" {
  description = "The location for Azure resources. (e.g 'uksouth')|1|azure_location"
  type        = string
}

variable "default_postfix" {
  description = "The default postfix for Azure resources. (e.g 'landing-zone')|2|azure_name"
  type        = string
  default     = "landing-zone"
}

variable "root_parent_management_group_id" {
  description = "This is the id of the management group that the ALZ hierarchy will be nested under, will default to the Tenant Root Group|3|azure_name"
  type        = string
  default     = ""
}

variable "subscription_id_management" {
  description = "value of the subscription id for the Management subscription|4|azure_subscription_id"
  type        = string
}

variable "subscription_id_connectivity" {
  description = "value of the subscription id for the Connectivity subscription|5|azure_subscription_id"
  type        = string
}

variable "subscription_id_identity" {
  description = "value of the subscription id for the Identity subscription|6|azure_subscription_id"
  type        = string
}

variable "configuration_file_path" {
  description = "The path of the configuration file|7|configuration_file_path"
  type        = string
  default     = ""
}
