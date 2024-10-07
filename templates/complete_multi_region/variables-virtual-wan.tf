variable "virtual_wan_settings" {
  type = any
  default = {
    name = "vwan-$${starter_location_01}"
    resource_group_name = "rg-vwan-$${starter_location_01}"
    location = "$${starter_location_01}"
    ddos_protection_plan = {
      name = "ddos-$${starter_location_01}"
      resource_group_name = "rg-ddos-$${starter_location_01}"
      location = "$${starter_location_01}"
    }
  }
}

variable "virtual_wan_virtual_hubs" {
  type = map(object({
    hub = any
    firewall = optional(any)
    private_dns_zones = optional(any)
  }))
  default = {
    primary = {
      hub = {
        name                = "vwan-hub-$${starter_location_01}"
        resource_group_name = "rg-vwan-hub-$${starter_location_01}"
        location            = "$${starter_location_01}"
        address_prefix      = "10.0.0.0/16"
      }
      firewall = {
        name     = "fw-hub-$${starter_location_01}"
        sku_name = "AZFW_Hub"
        sku_tier = "Standard"
        zones    = "$${starter_location_01_availability_zones}"
        firewall_policy = {
          name = "fwp-hub-$${starter_location_01}"
        }
      }
      private_dns_zones = {
        resource_group_name = "rg-vwan-dns-$${starter_location_01}"
        is_primary          = true
        networking = {
          virtual_network = {
            name          = "vnet-hub-dns-$${starter_location_01}"
            address_space = "10.10.0.0/24"
            private_dns_resolver_subnet = {
              name           = "subnet-hub-dns-$${starter_location_01}"
              address_prefix = "10.10.0.0/28"
            }
          }
          private_dns_resolver = {
            name = "pdr-hub-dns-$${starter_location_01}"
          }
        }
      }
    }
    secondary = {
      hub = {
        name                = "vwan-hub-$${starter_location_02}"
        resource_group_name = "rg-vwan-hub-$${starter_location_02}"
        location            = "$${starter_location_02}"
        address_prefix      = "10.1.0.0/16"
      }
      firewall = {
        name     = "fw-hub-$${starter_location_02}"
        sku_name = "AZFW_Hub"
        sku_tier = "Standard"
        zones    = "$${starter_location_02_availability_zones}"
        firewall_policy = {
          name = "fwp-hub-$${starter_location_02}"
        }
      }
      private_dns_zones = {
        resource_group_name = "rg-vwan-dns-$${starter_location_01}"
        is_primary          = false
        networking = {
          virtual_network = {
            name          = "vnet-hub-dns-$${starter_location_02}"
            address_space = "10.11.0.0/24"
            private_dns_resolver_subnet = {
              name           = "subnet-hub-dns-$${starter_location_02}"
              address_prefix = "10.11.0.0/28"
            }
          }
          private_dns_resolver = {
            name = "pdr-hub-dns-$${starter_location_02}"
          }
        }
      }
    }
  }
  description = "A map of virtual hubs to create. Detailed information about the virtual hub can be found in the module's README: https://registry.terraform.io/modules/Azure/avm-ptn-virtualhub"
}
