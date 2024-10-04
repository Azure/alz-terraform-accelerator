module "hub_and_spoke_vnet" {
  source  = "Azure/avm-ptn-hubnetworking/azurerm"
  version = "0.1.0"

  hub_virtual_networks = var.hub_virtual_networks
  enable_telemetry     = var.enable_telemetry
}

module "virtual_network_gateway" {
  source  = "Azure/avm-ptn-vnetgateway/azurerm"
  version = "0.3.1"

  for_each = local.virtual_network_gateways

  location                                  = each.value.location
  name                                      = each.value.name
  sku                                       = each.value.sku
  type                                      = each.value.type
  virtual_network_id                        = each.value.virtual_network_id
  default_tags                              = var.tags
  subnet_creation_enabled                   = try(each.value.settings.subnet_creation_enabled, null)
  edge_zone                                 = try(each.value.settings.edge_zone, null)
  express_route_circuits                    = try(each.value.settings.express_route_circuits, null)
  ip_configurations                         = try(each.value.settings.ip_configurations, null)
  local_network_gateways                    = try(each.value.settings.local_network_gateways, null)
  subnet_address_prefix                     = try(each.value.subnet_address_prefix, null)
  tags                                      = try(each.value.settings.tags, null)
  vpn_active_active_enabled                 = try(each.value.settings.vpn_active_active_enabled, null)
  vpn_bgp_enabled                           = try(each.value.settings.vpn_bgp_enabled, null)
  vpn_bgp_settings                          = try(each.value.settings.vpn_bgp_settings, null)
  vpn_generation                            = try(each.value.settings.vpn_generation, null)
  vpn_point_to_site                         = try(each.value.settings.vpn_point_to_site, null)
  vpn_type                                  = try(each.value.settings.vpn_type, null)
  vpn_private_ip_address_enabled            = try(each.value.settings.vpn_private_ip_address_enabled, null)
  route_table_bgp_route_propagation_enabled = try(each.value.settings.route_table_bgp_route_propagation_enabled, null)
  route_table_creation_enabled              = try(each.value.route_table_creation_enabled, null)
  route_table_name                          = try(each.value.settings.route_table_name, null)
  route_table_tags                          = try(each.value.settings.route_table_tags, null)
  enable_telemetry                          = var.enable_telemetry

  depends_on = [
    module.hub_and_spoke_vnet
  ]
}
