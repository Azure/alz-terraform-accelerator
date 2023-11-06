variable "default_location" {
  description = "The location for Azure resources. (e.g 'uksouth')|1|azure_location"
  type        = string
}

variable "default_postfix" {
  description = "The default postfix for Azure resources. (e.g 'landing-zone')|2|azure_name"
  type        = string
  default     = "landing-zone"
}

variable "subscription_id_connectivity" {
  description = "The identifier of the Connectivity Subscription. (e.g '00000000-0000-0000-0000-000000000000')|3|azure_subscription_id"
  type        = string
}

variable "subscription_id_identity" {
  description = "The identifier of the Identity Subscription. (e.g '00000000-0000-0000-0000-000000000000')|4|azure_subscription_id"
  type        = string
}

variable "subscription_id_management" {
  description = "The identifier of the Management Subscription. (e.g 00000000-0000-0000-0000-000000000000)|5|azure_subscription_id"
  type        = string
}
