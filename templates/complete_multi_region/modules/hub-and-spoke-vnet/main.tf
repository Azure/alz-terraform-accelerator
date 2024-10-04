module "hub_and_spoke_vnet" {
  source  = "Azure/avm-ptn-hubnetworking/azurerm"
  version = "0.1.0"

  hub_virtual_networks = local.hub_virtual_networks
  enable_telemetry     = var.enable_telemetry
}

module "virtual_network_gateway" {
  source  = "Azure/avm-ptn-vnetgateway/azurerm"
  version = "0.3.1"

  for_each = local.virtual_network_gateways

  location                                  = each.value.virtual_network_gateway.location
  name                                      = each.value.virtual_network_gateway.name
  sku                                       = each.value.virtual_network_gateway.sku
  type                                      = each.value.virtual_network_gateway.type
  virtual_network_id                        = module.hub_and_spoke_vnet.virtual_networks[each.value.hub_network_key].id
  default_tags                              = var.tags
  subnet_creation_enabled                   = try(each.value.virtual_network_gateway.settings.subnet_creation_enabled, null)
  edge_zone                                 = try(each.value.virtual_network_gateway.settings.edge_zone, null)
  express_route_circuits                    = try(each.value.virtual_network_gateway.settings.express_route_circuits, null)
  ip_configurations                         = try(each.value.virtual_network_gateway.settings.ip_configurations, null)
  local_network_gateways                    = try(each.value.virtual_network_gateway.settings.local_network_gateways, null)
  subnet_address_prefix                     = each.value.virtual_network_gateway.subnet_address_prefix
  tags                                      = try(each.value.virtual_network_gateway.settings.tags, null)
  vpn_active_active_enabled                 = try(each.value.virtual_network_gateway.settings.vpn_active_active_enabled, null)
  vpn_bgp_enabled                           = try(each.value.virtual_network_gateway.settings.vpn_bgp_enabled, null)
  vpn_bgp_settings                          = try(each.value.virtual_network_gateway.settings.vpn_bgp_settings, null)
  vpn_generation                            = try(each.value.virtual_network_gateway.settings.vpn_generation, null)
  vpn_point_to_site                         = try(each.value.virtual_network_gateway.settings.vpn_point_to_site, null)
  vpn_type                                  = try(each.value.virtual_network_gateway.settings.vpn_type, null)
  vpn_private_ip_address_enabled            = try(each.value.virtual_network_gateway.settings.vpn_private_ip_address_enabled, null)
  route_table_bgp_route_propagation_enabled = try(each.value.virtual_network_gateway.settings.route_table_bgp_route_propagation_enabled, null)
  route_table_creation_enabled              = try(each.value.virtual_network_gateway.route_table_creation_enabled, null)
  route_table_name                          = try(each.value.virtual_network_gateway.settings.route_table_name, null)
  route_table_tags                          = try(each.value.virtual_network_gateway.settings.route_table_tags, null)
  enable_telemetry                          = var.enable_telemetry

  depends_on = [
    module.hub_and_spoke_vnet
  ]
}
