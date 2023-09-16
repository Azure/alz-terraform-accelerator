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
  description = "The root id is the identity for the root managment group and a prefix applied to all management group identities|5|azure_name"
  type        = string
  default     = "es"
}

variable "root_name" {
  description = "The display name for the root management group|6|azure_name"
  type        = string
  default     = "Enterprise-Scale"
}

variable "hub_virtual_network_address_prefix" {
  description = "The IP address range for the hub network in CIDR format|7|cidr_range"
  type        = string
  default     = ""
}

variable "firewall_subnet_address_prefix" {
  description = "The IP address range foe the firewall subnet in CIDR format|8|cidr_range"
  type        = string
  default     = ""
}

variable "gateway_subnet_address_prefix" {
  description = "The IP address range foe the gatway subnet in CIDR format|9|cidr_range"
  type        = string
  default     = ""
}

variable "virtual_network_gateway_creation_enabled" {
  description = "Whether the virtual network gateway is created|10|bool"
  type        = bool
  default     = false
}
