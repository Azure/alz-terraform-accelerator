module "hub_and_spoke_vnet" {
  source  = "Azure/avm-ptn-hubnetworking/azurerm"
  version = "0.1.0"

  count = length(local.hub_virtual_networks) > 0 ? 1 : 0

  hub_virtual_networks = local.module_hub_and_spoke_vnet.hub_virtual_networks
  enable_telemetry     = try(local.module_hub_and_spoke_vnet.enable_telemetry, local.enable_telemetry)

  providers = {
    azurerm = azurerm.connectivity
  }

  depends_on = [
    module.management_groups
  ]
}

module "virtual_network_gateway" {
  source  = "Azure/avm-ptn-vnetgateway/azurerm"
  version = "0.3.1"

  for_each = local.module_virtual_network_gateway

  location                                  = each.value.location
  name                                      = each.value.name
  sku                                       = try(each.value.sku, null) == null ? local.vnet_gateway_default_skus[each.key] : each.value.sku
  type                                      = try(each.value.type, null)
  virtual_network_id                        = each.value.virtual_network_id
  default_tags                              = try(each.value.default_tags, null)
  subnet_creation_enabled                   = try(each.value.subnet_creation_enabled, null)
  edge_zone                                 = try(each.value.edge_zone, null)
  express_route_circuits                    = try(each.value.express_route_circuits, null)
  ip_configurations                         = try(each.value.ip_configurations, null)
  local_network_gateways                    = try(each.value.local_network_gateways, null)
  subnet_address_prefix                     = try(each.value.subnet_address_prefix, null)
  tags                                      = try(each.value.tags, null)
  vpn_active_active_enabled                 = try(each.value.vpn_active_active_enabled, null)
  vpn_bgp_enabled                           = try(each.value.vpn_bgp_enabled, null)
  vpn_bgp_settings                          = try(each.value.vpn_bgp_settings, null)
  vpn_generation                            = try(each.value.vpn_generation, null)
  vpn_point_to_site                         = try(each.value.vpn_point_to_site, null)
  vpn_type                                  = try(each.value.vpn_type, null)
  vpn_private_ip_address_enabled            = try(each.value.vpn_private_ip_address_enabled, null)
  route_table_bgp_route_propagation_enabled = try(each.value.route_table_bgp_route_propagation_enabled, null)
  route_table_creation_enabled              = try(each.value.route_table_creation_enabled, null)
  route_table_name                          = try(each.value.route_table_name, null)
  route_table_tags                          = try(each.value.route_table_tags, null)
  enable_telemetry                          = try(each.value.enable_telemetry, local.enable_telemetry)

  providers = {
    azurerm = azurerm.connectivity
  }

  depends_on = [ 
    module.hub_and_spoke_vnet
  ]
}
