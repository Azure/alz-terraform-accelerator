module "hub_and_spoke_vnet" {
  source  = "Azure/avm-ptn-hubnetworking/azurerm"
  version = "0.1.0"

  hub_virtual_networks = local.hub_virtual_networks
  enable_telemetry     = var.enable_telemetry
}

module "virtual_network_gateway" {
  source  = "Azure/avm-ptn-vnetgateway/azurerm"
  version = "0.5.0"

  for_each = local.virtual_network_gateways

  location                                  = each.value.virtual_network_gateway.location
  name                                      = each.value.virtual_network_gateway.name
  sku                                       = each.value.virtual_network_gateway.sku
  type                                      = each.value.virtual_network_gateway.type
  virtual_network_id                        = module.hub_and_spoke_vnet.virtual_networks[each.value.hub_network_key].id
  tags                                      = var.tags
  subnet_creation_enabled                   = try(each.value.virtual_network_gateway.subnet_creation_enabled, false)
  edge_zone                                 = try(each.value.virtual_network_gateway.edge_zone, null)
  express_route_circuits                    = try(each.value.virtual_network_gateway.express_route_circuits, null)
  ip_configurations                         = try(each.value.virtual_network_gateway.ip_configurations, null)
  local_network_gateways                    = try(each.value.virtual_network_gateway.local_network_gateways, null)
  subnet_address_prefix                     = try(each.value.virtual_network_gateway.subnet_address_prefix, null)
  vpn_active_active_enabled                 = try(each.value.virtual_network_gateway.vpn_active_active_enabled, null)
  vpn_bgp_enabled                           = try(each.value.virtual_network_gateway.vpn_bgp_enabled, null)
  vpn_bgp_settings                          = try(each.value.virtual_network_gateway.vpn_bgp_settings, null)
  vpn_generation                            = try(each.value.virtual_network_gateway.vpn_generation, null)
  vpn_point_to_site                         = try(each.value.virtual_network_gateway.vpn_point_to_site, null)
  vpn_type                                  = try(each.value.virtual_network_gateway.vpn_type, null)
  vpn_private_ip_address_enabled            = try(each.value.virtual_network_gateway.vpn_private_ip_address_enabled, null)
  route_table_bgp_route_propagation_enabled = try(each.value.virtual_network_gateway.route_table_bgp_route_propagation_enabled, null)
  route_table_creation_enabled              = try(each.value.virtual_network_gateway.route_table_creation_enabled, null)
  route_table_name                          = try(each.value.virtual_network_gateway.route_table_name, null)
  route_table_tags                          = try(each.value.virtual_network_gateway.route_table_tags, null)
  enable_telemetry                          = var.enable_telemetry

  depends_on = [
    module.hub_and_spoke_vnet
  ]
}

module "private_dns_zones" {
  source  = "Azure/avm-ptn-network-private-link-private-dns-zones/azurerm"
  version = "0.4.0"

  for_each = local.private_dns_zones

  location                                = each.value.location
  resource_group_name                     = each.value.resource_group_name
  resource_group_creation_enabled         = false
  virtual_network_resource_ids_to_link_to = local.private_dns_zones_virtual_network_links
  private_link_private_dns_zones          = try(each.value.is_primary, false) ? null : local.private_dns_zones_secondary_zones
  enable_telemetry                        = var.enable_telemetry
  tags                                    = var.tags
}

module "ddos_protection_plan" {
  source  = "Azure/avm-res-network-ddosprotectionplan/azurerm"
  version = "0.2.0"

  count = local.ddos_protection_plan_enabled ? 1 : 0

  name                = local.ddos_protection_plan.name
  resource_group_name = local.ddos_protection_plan.resource_group_name
  location            = local.ddos_protection_plan.location
  enable_telemetry    = var.enable_telemetry
  tags                = var.tags
}
