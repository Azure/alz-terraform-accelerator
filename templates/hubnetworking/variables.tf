variable "default_location" {
  description = "value of the default location"
  type        = string
}

variable "subscription_id_connectivity" {
  description = "value of the subscription id for the Connectivity subscription"
  type        = string
}

variable "subscription_id_identity" {
  description = "value of the subscription id for the Identity subscription"
  type        = string
}

variable "subscription_id_management" {
  description = "value of the subscription id for the Management subscription"
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

variable "hub_virtual_network_address_prefix" {
  description = "value of the hub virtual network address prefix"
  type        = string
  default     = ""
}

variable "firewall_subnet_address_prefix" {
  description = "value of the firewall subnet address prefix"
  type        = string
  default     = ""
}

variable "gateway_subnet_address_prefix" {
  description = "value of the gateway subnet address prefix"
  type        = string
  default     = ""
}

variable "virtual_network_gateway_creation_enabled" {
  description = "value of the virtual network gateway creation enabled"
  type        = bool
  default     = false
}
