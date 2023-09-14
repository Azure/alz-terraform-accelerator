variable "default_location" {
  description = "The location for Azure resources. (e.g 'uksouth')|1|azure_location"
  type        = string
}

variable "subscription_id_connectivity" {
  description = "The identifier of the Connectivity Subscription. (e.g '00000000-0000-0000-0000-000000000000')|2|azure_subscription_id"
  type        = string
}

variable "subscription_id_identity" {
  description = "The identifier of the Identity Subscription. (e.g '00000000-0000-0000-0000-000000000000')|3|azure_subscription_id"
  type        = string
}

variable "subscription_id_management" {
  description = "The identifier of the Management Subscription. (e.g 00000000-0000-0000-0000-000000000000)|4|azure_subscription_id"
  type        = string
}

variable "root_id" {
  description = "value of the root id|5|azure_name"
  type        = string
  default     = "es"
}

variable "root_name" {
  description = "value of the root name|6|azure_name"
  type        = string
  default     = "Enterprise-Scale"
}

variable "hub_virtual_network_address_prefix" {
  description = "value of the hub virtual network address prefix|7|azure_address_prefix"
  type        = string
  default     = ""
}

variable "firewall_subnet_address_prefix" {
  description = "value of the firewall subnet address prefix|8|azure_address_prefix"
  type        = string
  default     = ""
}

variable "gateway_subnet_address_prefix" {
  description = "value of the gateway subnet address prefix|9|azure_address_prefix"
  type        = string
  default     = ""
}

variable "virtual_network_gateway_creation_enabled" {
  description = "value of the virtual network gateway creation enabled|10|bool"
  type        = bool
  default     = false
}
