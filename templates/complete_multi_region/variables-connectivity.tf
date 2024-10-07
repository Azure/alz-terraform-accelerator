variable "connectivity_type" {
  type        = string
  description = "The type of connectivity to use for the private DNS zones"
  default     = "hub_and_spoke_vnet"
  validation {
    condition     = contains(["hub_and_spoke_vnet", "virtual_wan", "none"], var.connectivity_type)
    error_message = "The connectivity type must be either 'hub_and_spoke_vnet', 'virtual_wan' or 'none'"
  }
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
