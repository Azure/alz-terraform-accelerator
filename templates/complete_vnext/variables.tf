variable "default_location" {
  type        = string
  description = "The location for Azure resources. (e.g 'uksouth')|1|azure_location"
}

variable "subscription_id_connectivity" {
  type        = string
  description = "The identifier of the Connectivity Subscription. (e.g '00000000-0000-0000-0000-000000000000')|4|azure_subscription_id"
}

variable "subscription_id_identity" {
  type        = string
  description = "The identifier of the Identity Subscription. (e.g '00000000-0000-0000-0000-000000000000')|5|azure_subscription_id"
}

variable "subscription_id_management" {
  type        = string
  description = "The identifier of the Management Subscription. (e.g 00000000-0000-0000-0000-000000000000)|6|azure_subscription_id"
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
  description = "The identifier of the Tenant Root Management Group, if left blank will use the tenant id. (e.g '00000000-0000-0000-0000-000000000000')|3|azure_name"
}
