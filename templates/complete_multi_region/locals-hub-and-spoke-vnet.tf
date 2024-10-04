locals {
  hub_and_spoke_vnet_gateway_default_skus = { for key, value in var.hub_and_spoke_vnet_virtual_networks : key => length(local.regions[value.location].zones) == 0 ? {
      express_route = "Standard"
      vpn        = "VpnGw1"
    } : {
      express_route = "ErGw1AZ"
      vpn         = "VpnGw1AZ"
    } 
  }
  
  hub_and_spoke_vnet_virtual_networks = {
    for key, value in var.hub_and_spoke_vnet_virtual_networks : key => {
      name                            = templatestring(value.name, { location = value.location })
      location                        = value.location
      resource_group_name             = templatestring(value.resource_group_name, { location = value.location })
      settings                        = value.settings
      virtual_network_gateways = {
        express_route = try({
          name     = templatestring(value.virtual_network_gateways.express_route.name, { location = value.location })
          sku      = value.virtual_network_gateways.express_route.sku == null ? local.hub_and_spoke_vnet_gateway_default_skus[key].express_route : value.virtual_network_gateways.express_route.sku
          settings = value.virtual_network_gateways.express_route.settings
        }, null)
        vpn = try({
          name     =  templatestring(value.virtual_network_gateways.vpn.name, { location = value.location })
          sku      =  value.virtual_network_gateways.vpn.sku == null ? local.hub_and_spoke_vnet_gateway_default_skus[key].vpn : value.virtual_network_gateways.vpn.sku
          settings =  value.virtual_network_gateways.vpn.settings
        }, null)
      }
    }
  }
}
