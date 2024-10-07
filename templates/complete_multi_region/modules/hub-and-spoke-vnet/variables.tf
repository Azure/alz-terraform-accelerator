variable "hub_and_spoke_networks_settings" {
  type = any
}

variable "hub_virtual_networks" {
  type = map(object({
    hub_virtual_network = any
    virtual_network_gateways = optional(object({
      express_route = optional(any)
      vpn = optional(any)
    }))
    private_dns_zones = optional(object({
      resource_group_name = string
      is_primary          = optional(bool, false)
    }))
  }))
  default     = {}
  description = "A map of hub networks to create. Detailed information about the hub network can be found in the module's README: https://registry.terraform.io/modules/Azure/avm-ptn-hubnetworking"
}

variable "enable_telemetry" {
  default     = true
  type        = bool
  description = "Flag to enable/disable telemetry"
}

variable "tags" {
  default     = {}
  type        = map(string)
  description = "A map of tags to add to the private DNS zones"
}
