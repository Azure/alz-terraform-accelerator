variable "default_location" {
  type        = string
  description = "The location for Azure resources. (e.g 'uksouth')|1|azure_location"
}

variable "subscription_id_connectivity" {
  type        = string
  description = "The identifier of the Connectivity Subscription. (e.g '00000000-0000-0000-0000-000000000000')|3|azure_subscription_id"
}

variable "subscription_id_identity" {
  type        = string
  description = "The identifier of the Identity Subscription. (e.g '00000000-0000-0000-0000-000000000000')|4|azure_subscription_id"
}

variable "subscription_id_management" {
  type        = string
  description = "The identifier of the Management Subscription. (e.g 00000000-0000-0000-0000-000000000000)|5|azure_subscription_id"
}

variable "root_id" {
  type        = string
  default     = "es"
  description = "The root id is the identity for the root management group and a prefix applied to all management group identities|6|azure_name"
}

variable "root_name" {
  type        = string
  default     = "Enterprise-Scale"
  description = "The display name for the root management group|7|azure_name"
}

variable "root_parent_management_group_id" {
  type        = string
  default     = ""
  description = "The parent management group id. Defaults to `Tenant Root Group` if not supplied.|2"
}
