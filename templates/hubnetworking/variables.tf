variable "starter_locations" {
  description = "The location for Azure resources. (e.g 'uksouth')|azure_location"
  type        = list(string)
}

variable "root_parent_management_group_id" {
  description = "The parent management group id. Defaults to `Tenant Root Group` if not supplied."
  type        = string
  default     = ""
}

variable "subscription_id_connectivity" {
  description = "The identifier of the Connectivity Subscription. (e.g '00000000-0000-0000-0000-000000000000')|azure_subscription_id"
  type        = string
}

variable "subscription_id_identity" {
  description = "The identifier of the Identity Subscription. (e.g '00000000-0000-0000-0000-000000000000')|azure_subscription_id"
  type        = string
}

variable "subscription_id_management" {
  description = "The identifier of the Management Subscription. (e.g 00000000-0000-0000-0000-000000000000)|azure_subscription_id"
  type        = string
}

variable "root_id" {
  description = "The root id is the identity for the root management group and a prefix applied to all management group identities|azure_name"
  type        = string
  default     = "es"
}

variable "root_name" {
  description = "The display name for the root management group|azure_name"
  type        = string
  default     = "Enterprise-Scale"
}

variable "hub_virtual_network_address_prefix" {
  description = "The IP address range for the hub network in CIDR format|cidr_range"
  type        = string
  default     = "10.0.0.0/16"
}

variable "firewall_subnet_address_prefix" {
  description = "The IP address range for the firewall subnet in CIDR format|cidr_range"
  type        = string
  default     = "10.0.0.0/24"
}

variable "gateway_subnet_address_prefix" {
  description = "The IP address range for the gateway subnet in CIDR format|cidr_range"
  type        = string
  default     = "10.0.1.0/24"
}

variable "virtual_network_gateway_creation_enabled" {
  description = "Whether the virtual network gateway is created"
  type        = bool
  default     = false
}
