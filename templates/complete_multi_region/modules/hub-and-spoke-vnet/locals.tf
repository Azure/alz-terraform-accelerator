locals {
  virtual_network_gateways_express_route = {
    for hub_network_key, hub_network_value in var.hub_virtual_networks : "${hub_network_key}-express-route" => {
      name               = hub_network_value.virtual_network_gateways.express_route.settings.name
      type               = "ExpressRoute"
      sku                = hub_network_value.sku
      location           = hub_network_value.location
      virtual_network_id = module.hub_module.hub_and_spoke_vnet.virtual_networks[hub_network_key].id
      settings           = hub_network_value.virtual_network_gateways.express_route.settings
    } if can(hub_network_value.virtual_network_gateways.express_route)
  }
  virtual_network_gateways_vpn = {
    for hub_network_key, hub_network_value in var.hub_virtual_networks : "${hub_network_key}-vpn" => {
      name               = hub_network_value.virtual_network_gateways.vpn.settings.name
      type               = "Vpn"
      sku                = hub_network_value.sku
      location           = hub_network_value.location
      virtual_network_id = module.hub_module.hub_and_spoke_vnet.virtual_networks[hub_network_key].id
      settings           = hub_network_value.virtual_network_gateways.vpn.settings
    } if can(hub_network_value.virtual_network_gateways.vpn)
  }
  virtual_network_gateways = merge(local.virtual_network_gateways_express_route, local.virtual_network_gateways_vpn)
}
