variable "connectivity_type" {
  type        = string
  description = "The type of connectivity to use for the private DNS zones"
  default     = "hub_and_spoke_vnet"
  validation {
    condition     = contains(["hub_and_spoke_vnet", "virtual_wan", "none"], var.connectivity_type)
    error_message = "The connectivity type must be either 'hub_and_spoke_vnet', 'virtual_wan' or 'none'"
  }
}

variable "private_dns_zones_enabled" {
  type        = bool
  description = "Flag to enable/disable private DNS zones"
  default     = true
}

variable "private_dns_zones_resource_group_name" {
  type        = string
  description = "The name of the resource group for private DNS zones"
  default     = "rg-private-dns-$${location}"
}

variable "private_dns_zones_resource_group_location" {
  type        = string
  description = "The location of the resource group for private DNS zones"
  default     = null
}

variable "private_dns_zones_tags" {
  type        = map(string)
  description = "A map of tags to add to the private DNS zones"
  default     = {}
}

variable "ddos_protection_plan_enabled" {
  type        = bool
  description = "Flag to enable/disable DDoS protection plan"
  default     = true
}

variable "ddos_protection_plan_resource_group_name" {
  type        = string
  description = "The name of the resource group for DDoS protection plan"
  default     = "rg-ddos-$${location}"
}

variable "ddos_protection_plan_resource_group_location" {
  type        = string
  description = "The location of the resource group for DDoS protection plan"
  default     = null
}

variable "ddos_protection_plan_name" {
  type        = string
  description = "The name of the DDoS protection plan"
  default     = "ddos-$${location}"
}
