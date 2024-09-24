module "virtual_wan" {
  source  = "Azure/avm-ptn-virtualwan/azurerm"
  version = "0.5.0"

  count = local.virtual_wan_enabled ? 1 : 0

  allow_branch_to_branch_traffic        = try(local.module_virtual_wan.allow_branch_to_branch_traffic, null)
  create_resource_group                 = try(local.module_virtual_wan.create_resource_group, null)
  disable_vpn_encryption                = try(local.module_virtual_wan.disable_vpn_encryption, null)
  er_circuit_connections                = try(local.module_virtual_wan.er_circuit_connections, null)
  expressroute_gateways                 = try(local.module_virtual_wan.expressroute_gateways, null)
  firewalls                             = try(local.module_virtual_wan.firewalls, null)
  office365_local_breakout_category     = try(local.module_virtual_wan.office365_local_breakout_category, null)
  location                              = try(local.module_virtual_wan.location, null)
  p2s_gateway_vpn_server_configurations = try(local.module_virtual_wan.p2s_gateway_vpn_server_configurations, null)
  p2s_gateways                          = try(local.module_virtual_wan.p2s_gateways, null)
  resource_group_name                   = try(local.module_virtual_wan.resource_group_name, null)
  virtual_hubs                          = try(local.module_virtual_wan.virtual_hubs, null)
  virtual_network_connections           = try(local.module_virtual_wan.virtual_network_connections, null)
  virtual_wan_name                      = try(local.module_virtual_wan.virtual_wan_name, null)
  type                                  = try(local.module_virtual_wan.type, null)
  routing_intents                       = try(local.module_virtual_wan.routing_intents, null)
  resource_group_tags                   = try(local.module_virtual_wan.resource_group_tags, null)
  virtual_wan_tags                      = try(local.module_virtual_wan.virtual_wan_tags, null)
  vpn_gateways                          = try(local.module_virtual_wan.vpn_gateways, null)
  vpn_site_connections                  = try(local.module_virtual_wan.vpn_site_connections, null)
  vpn_sites                             = try(local.module_virtual_wan.vpn_sites, null)
  tags                                  = try(local.module_virtual_wan.tags, null)
  enable_telemetry                      = try(local.module_virtual_wan.enable_telemetry, local.enable_telemetry)

  providers = {
    azurerm = azurerm.connectivity
  }

  depends_on = [
    module.management_groups
  ]
}

module "virtual_network_private_dns" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm"
  version = "0.4.0"

  count = local.virtual_wan_enabled ? 1 : 0

  address_space       = [try(local.module_hub_and_spoke_vnet.private_dns_virtual_network_address_space, null)]
  location            = try(local.module_virtual_wan.private_dns_location, var.starter_locations[0])
  name                = try(local.module_hub_and_spoke_vnet.private_dns_virtual_network_name, "vnet-private-dns")
  resource_group_name = try(local.module_virtual_wan.resource_group_name, null)
  enable_telemetry    = try(local.module_virtual_wan.enable_telemetry, local.enable_telemetry)
}