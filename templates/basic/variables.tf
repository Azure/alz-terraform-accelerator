variable "default_location" {
  description = "The location for Azure resources. (e.g 'uksouth')"
  type        = string
}

variable "subscription_id_connectivity" {
  description = "The identifier of the Connectivity Subscription. (e.g '00000000-0000-0000-0000-000000000000')"
  type        = string
}

variable "subscription_id_identity" {
  description = "The identifier of the Identity Subscription. (e.g '00000000-0000-0000-0000-000000000000')"
  type        = string
}

variable "subscription_id_management" {
  description = "The identifier of the Management Subscription. (e.g 00000000-0000-0000-0000-000000000000)"
  type        = string
}

variable "root_id" {
  description = "value of the root id"
  type        = string
  default     = "es"
}

variable "root_name" {
  description = "value of the root name"
  type        = string
  default     = "Enterprise-Scale"
}
