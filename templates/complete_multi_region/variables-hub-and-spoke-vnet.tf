variable "hub_and_spoke_vnet_virtual_networks" {
  type = map(object({
    hub_virtual_network = any
    virtual_network_gateways = optional(object({
      express_route = optional(any)
      vpn = optional(any)
    }))
  }))
  description = "A map of hub networks to create. Detailed information about the hub network can be found in the module's README: https://registry.terraform.io/modules/Azure/avm-ptn-hubnetworking"
  default = {
    primary = {
      hub_virtual_network = {
        name                = "vnet-hub-$${starter_location_01}"
        resource_group_name = "rg-hub-$${starter_location_01}"
        location            = "$${starter_location_01}"
        address_space = ["10.0.0.0/16"]
        firewall = {
          subnet_address_prefix = "10.0.0.0/24"
          name     = "fw-hub-$${starter_location_01}"
          sku_name = "AZFW_VNet"
          sku_tier = "Standard"
          zones    = "$${starter_location_01_availability_zones}"
          default_ip_configuration = {
            public_ip_config = {
              name       = "pip-fw-hub-$${starter_location_01}"
              zones      = "$${starter_location_01_availability_zones}"
            }
          }
          firewall_policy = {
            name = "fwp-hub-$${starter_location_01}"
          }
        }
      }
      virtual_network_gateways = {
        express_route = {
          location            = "$${starter_location_01}"
          subnet_address_prefix = "10.0.1.0/24"
          name                  = "vgw-hub-expressroute-$${starter_location_01}"
          type                 = "ExpressRoute"
          sku                   = "$${starter_location_01_virtual_network_gateway_sku}"
        }
        vpn = {
          location            = "$${starter_location_01}"
          subnet_address_prefix = "10.0.2.0/24"
          name                  = "vgw-hub-vpn-$${starter_location_01}"
          type                 = "Vpn"
          sku                   = "$${starter_location_01_virtual_network_gateway_sku}"
        }
      }
    }
    secondary = {
      hub_virtual_network = {
        name                = "vnet-hub-$${starter_location_02}"
        resource_group_name = "rg-hub-$${starter_location_02}"
        location            = "$${starter_location_02}"
        address_space = ["10.1.0.0/16"]
        firewall = {
          subnet_address_prefix = "10.1.0.0/24"
          name     = "fw-hub-$${starter_location_02}"
          sku_name = "AZFW_VNet"
          sku_tier = "Standard"
          zones    = "$${starter_location_02_availability_zones}"
          default_ip_configuration = {
            public_ip_config = {
              name       = "pip-fw-hub-$${starter_location_02}"
              zones      = "$${starter_location_02_availability_zones}"
            }
          }
          firewall_policy = {
            name = "fwp-hub-$${starter_location_01}"
          }
        }
      }
      virtual_network_gateways = {
        express_route = {
          location            = "$${starter_location_02}"
          subnet_address_prefix = "10.1.1.0/24"
          name                  = "vgw-hub-expressroute-$${starter_location_02}"
          type                 = "ExpressRoute"
          sku                   = "$${starter_location_02_virtual_network_gateway_sku}"
        }
        vpn = {
          location            = "$${starter_location_02}"
          subnet_address_prefix = "10.1.2.0/24"
          name                  = "vgw-hub-vpn-$${starter_location_02}"
          type                 = "Vpn"
          sku                   = "$${starter_location_02_virtual_network_gateway_sku}"
        }
      }
    }
  }
}
