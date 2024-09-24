module "virtual_wan_resource_group" {
  source  = "Azure/avm-res-resources-resourcegroup/azurerm"
  version = "0.1.0"

  count = local.virtual_wan_enabled ? 1 : 0

  name             = try(local.module_virtual_wan.resource_group_name, "rg-connectivity-${var.starter_locations[0]}")
  location         = try(local.module_virtual_wan.location, var.starter_locations[0])
  enable_telemetry = try(local.module_virtual_wan.enable_telemetry, local.enable_telemetry)

  providers = {
    azurerm = azurerm.connectivity
  }
}

module "firewall_policy" {
  source  = "Azure/avm-res-network-firewallpolicy/azurerm"
  version = "0.2.3"

  for_each = local.virtual_wan_enabled ? try(local.module_virtual_wan.firewalls, {}) : {}

  name                                              = each.value.firewall_policy.name
  location                                          = try(each.value.firewall_policy.location, try(local.module_virtual_wan.location, var.starter_locations[0]))
  resource_group_name                               = try(local.module_virtual_wan.resource_group_name, module.virtual_wan_resource_group[0].name)
  firewall_policy_sku                               = try(each.value.firewall_policy.sku, "Standard")
  firewall_policy_auto_learn_private_ranges_enabled = try(each.value.firewall_policy.auto_learn_private_ranges_enabled, null)
  firewall_policy_base_policy_id                    = try(each.value.firewall_policy.base_policy_id, null)
  firewall_policy_dns                               = try(each.value.firewall_policy.dns, null)
  firewall_policy_threat_intelligence_mode          = try(each.value.firewall_policy.threat_intelligence_mode, "Alert")
  firewall_policy_private_ip_ranges                 = try(each.value.firewall_policy.private_ip_ranges, null)
  firewall_policy_threat_intelligence_allowlist     = try(each.value.firewall_policy.threat_intelligence_allowlist, null)
  tags                                              = try(each.value.firewall_policy.tags, null)
  enable_telemetry                                  = try(local.module_virtual_wan.enable_telemetry, local.enable_telemetry)

  depends_on = [
    module.virtual_wan_resource_group
  ]
}

module "virtual_wan" {
  source  = "Azure/avm-ptn-virtualwan/azurerm"
  version = "0.5.0"

  count = local.virtual_wan_enabled ? 1 : 0

  allow_branch_to_branch_traffic        = try(local.module_virtual_wan.allow_branch_to_branch_traffic, null)
  create_resource_group                 = try(local.module_virtual_wan.create_resource_group, false)
  disable_vpn_encryption                = try(local.module_virtual_wan.disable_vpn_encryption, false)
  er_circuit_connections                = try(local.module_virtual_wan.er_circuit_connections, {})
  expressroute_gateways                 = try(local.module_virtual_wan.expressroute_gateways, {})
  firewalls                             = local.virtual_wan_firewalls
  office365_local_breakout_category     = try(local.module_virtual_wan.office365_local_breakout_category, null)
  location                              = try(local.module_virtual_wan.location, null)
  p2s_gateway_vpn_server_configurations = try(local.module_virtual_wan.p2s_gateway_vpn_server_configurations, {})
  p2s_gateways                          = try(local.module_virtual_wan.p2s_gateways, {})
  resource_group_name                   = try(local.module_virtual_wan.resource_group_name, module.virtual_wan_resource_group[0].name)
  virtual_hubs                          = try(local.module_virtual_wan.virtual_hubs, null)
  virtual_network_connections           = try(local.module_virtual_wan.virtual_network_connections, null)
  virtual_wan_name                      = try(local.module_virtual_wan.virtual_wan_name, null)
  type                                  = try(local.module_virtual_wan.type, null)
  routing_intents                       = try(local.module_virtual_wan.routing_intents, null)
  resource_group_tags                   = try(local.module_virtual_wan.resource_group_tags, null)
  virtual_wan_tags                      = try(local.module_virtual_wan.virtual_wan_tags, null)
  vpn_gateways                          = try(local.module_virtual_wan.vpn_gateways, {})
  vpn_site_connections                  = try(local.module_virtual_wan.vpn_site_connections, {})
  vpn_sites                             = try(local.module_virtual_wan.vpn_sites, null)
  tags                                  = try(local.module_virtual_wan.tags, null)
  enable_telemetry                      = try(local.module_virtual_wan.enable_telemetry, local.enable_telemetry)

  providers = {
    azurerm = azurerm.connectivity
  }

  depends_on = [
    module.management_groups,
    module.virtual_wan_resource_group
  ]
}

module "virtual_network_private_dns" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm"
  version = "0.4.0"

  for_each = local.virtual_wan_enabled ? try(local.module_virtual_wan.virtual_hubs, {}) : {}

  address_space       = [try(each.value.private_dns_virtual_network_address_space, null)]
  location            = try(each.value.location, var.starter_locations[0])
  name                = try(each.value.private_dns_virtual_network_name, "vnet-private-dns-${each.value.location}")
  resource_group_name = try(local.module_virtual_wan.resource_group_name, module.virtual_wan_resource_group[0].name)
  enable_telemetry    = try(local.module_virtual_wan.enable_telemetry, local.enable_telemetry)

  depends_on = [module.virtual_wan_resource_group]
}
