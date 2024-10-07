variable "connectivity_type" {
  type        = string
  description = "The type of connectivity to use for the private DNS zones"
  default     = "hub_and_spoke_vnet"
  validation {
    condition     = contains(values(local.const.connectivity), var.connectivity_type)
    error_message = "The connectivity type must be either 'hub_and_spoke_vnet', 'virtual_wan' or 'none'"
  }
}
