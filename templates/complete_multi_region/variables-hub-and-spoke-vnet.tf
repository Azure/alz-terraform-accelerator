variable "hub_and_spoke_vnet_virtual_networks" {
  type = map(object({
    location = string
    hub_virtual_network = object({
      name                = optional(string, "vnet-hub-$${location}")
      resource_group_name = optional(string, "rg-hub-$${location}")
      address_space       = list(string)
      firewall = optional(object({
        name     = optional(string, "fw-hub-$${location}")
        subnet_address_prefix = string
        default_ip_configuration = optional(object({
          public_ip_config = optional(object({
            name       = optional(string, "pip-fw-hub-$${location}")
          }))
        }))
        firewall_policy = optional(object({
          name = optional(string, "fwp-hub-$${location}")
        }))
      }))
    })
    virtual_network_gateways = optional(object({
      express_route = optional(object({
        subnet_address_prefix = string
        name                  = optional(string, "vgw-hub-expressroute-$${location}")
      }))
      vpn = optional(object({
        subnet_address_prefix = string
        name                  = optional(string, "vgw-hub-vpn-$${location}")
      }))
    }))
  }))
  description = "A map of hub networks to create. Detailed information about the hub network can be found in the module's README: https://registry.terraform.io/modules/Azure/avm-ptn-hubnetworking"
  default = {
    primary = {
      location      = "uksouth"
      hub_virtual_network = {
        address_space = ["10.0.0.0/16"]
        firewall = {
          subnet_address_prefix = "10.0.0.0/24"
        }
      }
      virtual_network_gateways = {
        express_route = {
          subnet_address_prefix = "10.0.1.0/24"
        }
        vpn = {
          subnet_address_prefix = "10.0.2.0/24"
        }
      }
    }
    secondary = {
      location      = "ukwest"
      hub_virtual_network = {
        address_space = ["10.1.0.0/16"]
        firewall = {
          subnet_address_prefix = "10.1.0.0/24"
        }
      }
      virtual_network_gateways = {
        express_route = {
          subnet_address_prefix = "10.1.1.0/24"
        }
        vpn = {
          subnet_address_prefix = "10.1.2.0/24"
        }
      }
    }
  }
}

variable "hub_and_spoke_vnet_virtual_networks_overrides" {
  type = map(object({
    hub_virtual_network = any
    virtual_network_gateways = optional(object({
      express_route = optional(any)
      vpn = optional(any)
    }))
  }))
  default = {}
}
