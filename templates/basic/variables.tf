variable "default_location" {
  description = "The location for Azure resources. (e.g 'uksouth')|azure_location"
  type        = string
}

variable "subscription_id_connectivity" {
  description = "The identifier of the Connectivity Subscription. (e.g '00000000-0000-0000-0000-000000000000')|guid"
  type        = string
}

variable "subscription_id_identity" {
  description = "The identifier of the Identity Subscription. (e.g '00000000-0000-0000-0000-000000000000')|guid"
  type        = string
}

variable "subscription_id_management" {
  description = "The identifier of the Management Subscription. (e.g 00000000-0000-0000-0000-000000000000)|guid"
  type        = string
}

variable "root_id" {
  description = "value of the root id|azure_name"
  type        = string
  default     = "es"
}

variable "root_name" {
  description = "value of the root name|azure_name"
  type        = string
  default     = "Enterprise-Scale"
}
