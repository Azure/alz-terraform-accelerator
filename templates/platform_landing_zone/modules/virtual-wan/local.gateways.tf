locals {
  virtual_network_gateways_express_route = {
    for virtual_hub_key, virtual_hub_value in var.virtual_hubs : virtual_hub_key => merge({
      virtual_hub_key = virtual_hub_key
    }, virtual_hub_value.virtual_network_gateways.express_route) if try(virtual_hub_value.virtual_network_gateways.express_route, null) != null
  }
  virtual_network_gateways_vpn = {
    for virtual_hub_key, virtual_hub_value in var.virtual_hubs : virtual_hub_key => merge({
      virtual_hub_key = virtual_hub_key
    }, virtual_hub_value.virtual_network_gateways.vpn) if try(virtual_hub_value.virtual_network_gateways.vpn, null) != null
  }
}
