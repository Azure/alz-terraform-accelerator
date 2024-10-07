variable "hub_and_spoke_vnet_settings" {
  type    = any
  default = {}
}

variable "hub_and_spoke_vnet_virtual_networks" {
  type = map(object({
    hub_virtual_network = any
    virtual_network_gateways = optional(object({
      express_route = optional(any)
      vpn           = optional(any)
    }))
    private_dns_zones = optional(any)
  }))
  description = "A map of hub networks to create. Detailed information about the hub network can be found in the module's README: https://registry.terraform.io/modules/Azure/avm-ptn-hubnetworking"
  default     = {}
}
