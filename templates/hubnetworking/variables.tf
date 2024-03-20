variable "default_location" {
  description = "The location for Azure resources. (e.g 'uksouth')|1|azure_location"
  type        = string
}

variable "root_parent_management_group_id" {
  description = "The parent management group id. Defaults to `Tenant Root Group` if not supplied.|2"
  type        = string
  default     = ""
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

variable "root_id" {
  description = "The root id is the identity for the root management group and a prefix applied to all management group identities|6|azure_name"
  type        = string
  default     = "es"
}

variable "root_name" {
  description = "The display name for the root management group|7|azure_name"
  type        = string
  default     = "Enterprise-Scale"
}

variable "hub_virtual_network_address_prefix" {
  description = "The IP address range for the hub network in CIDR format|8|cidr_range"
  type        = string
}

variable "firewall_subnet_address_prefix" {
  description = "The IP address range for the firewall subnet in CIDR format|9|cidr_range"
  type        = string
}

variable "gateway_subnet_address_prefix" {
  description = "The IP address range for the gateway subnet in CIDR format|10|cidr_range"
  type        = string
}

variable "virtual_network_gateway_creation_enabled" {
  description = "Whether the virtual network gateway is created|11|bool"
  type        = bool
  default     = false
}
