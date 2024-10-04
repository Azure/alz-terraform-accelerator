output "debug" {
  value = local.hub_and_spoke_vnet_virtual_networks
}

locals {
  hub_and_spoke_vnet_gateway_default_skus = { for key, value in var.hub_and_spoke_vnet_virtual_networks : key => length(local.regions[value.location].zones) == 0 ? {
    express_route = "Standard"
    vpn           = "VpnGw1"
    } : {
    express_route = "ErGw1AZ"
    vpn           = "VpnGw1AZ"
    }
  }

  hub_and_spoke_vnet_virtual_networks_template = {
    for key, value in var.hub_and_spoke_vnet_virtual_networks : key => {
      hub_virtual_network = {
        name                = templatestring(value.name, { location = value.location })
        resource_group_name = templatestring(value.resource_group_name, { location = value.location })
        location            = value.location
        firewall = try({
          name     = templatestring(value.firewall.name, { location = value.location })
          sku_name = "AZFW_VNet"
          sku_tier = "Standard"
          zones    = local.regions[value.location].zones
          default_ip_configuration = try({
            public_ip_config = {
              name       = templatestring(value.firewall.default_ip_configuration.public_ip_config.name, { location = value.location })
              zones      = local.regions[value.location].zones
            }
          })
          firewall_policy = {
            name = templatestring(value.firewall.firewall_policy.name, { location = value.location })
          }
        }, null)
      }
      virtual_network_gateways = {
        express_route = try({
          name     = templatestring(value.virtual_network_gateways.express_route.name, { location = value.location })
          sku      = local.hub_and_spoke_vnet_gateway_default_skus[key].express_route
          type     = "ExpressRoute"
          location = value.location
        }, null)
        vpn = try({
          name     = templatestring(value.virtual_network_gateways.vpn.name, { location = value.location })
          sku      = local.hub_and_spoke_vnet_gateway_default_skus[key].vpn
          type     = "Vpn"
          location = value.location
        }, null)
      }
    }
  }

  hub_and_spoke_vnet_virtual_networks = merge(local.hub_and_spoke_vnet_virtual_networks_template, var.hub_and_spoke_vnet_virtual_networks, var.hub_and_spoke_vnet_virtual_networks_overrides)
}
