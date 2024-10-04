variable "hub_and_spoke_vnet_virtual_networks" {
  type = map(object({
    name                = optional(string, "vnet-hub-$${location}")
    location            = string
    resource_group_name = optional(string, "rg-hub-$${location}")
    settings            = object
    virtual_network_gateways = optional(object({
      express_route = optional(object({
        name     = optional(string, "vgw-hub-expressroute-$${location}")
        sku      = optional(string)
        settings = object
      }))
      vpn = optional(object({
        name     = optional(string, "vgw-hub-vpn-$${location}")
        sku      = optional(string)
        settings = object
      }))
    }))
  }))
  default     = {}
  description = "A map of hub networks to create. Detailed information about the hub network can be found in the module's README: https://registry.terraform.io/modules/Azure/avm-ptn-hubnetworking"
}
