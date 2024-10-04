module "firewall_policy" {
  source  = "Azure/avm-res-network-firewallpolicy/azurerm"
  version = "0.2.3"

  for_each = local.firewall_policies

  name                                              = each.value.name
  location                                          = each.value.location
  resource_group_name                               = each.value.resource_group_name
  firewall_policy_sku                               = try(each.value.settings.sku, "Standard")
  firewall_policy_auto_learn_private_ranges_enabled = try(each.value.settings.auto_learn_private_ranges_enabled, null)
  firewall_policy_base_policy_id                    = try(each.value.settings.base_policy_id, null)
  firewall_policy_dns = try(each.value.settings.dns, {
    servers       = [module.dns_resolver[each.value.virtual_hub_key].inbound_endpoint_ips["dns"]]
    proxy_enabled = true
  })
  firewall_policy_threat_intelligence_mode      = try(each.value.settings.threat_intelligence_mode, "Alert")
  firewall_policy_private_ip_ranges             = try(each.value.settings.private_ip_ranges, null)
  firewall_policy_threat_intelligence_allowlist = try(each.value.settings.threat_intelligence_allowlist, null)
  tags                                          = try(each.value.settings.tags, null)
  enable_telemetry                              = var.enable_telemetry
}

module "virtual_wan" {
  source  = "Azure/avm-ptn-virtualwan/azurerm"
  version = "0.5.0"

  allow_branch_to_branch_traffic        = try(local.module_virtual_wan.allow_branch_to_branch_traffic, null)
  disable_vpn_encryption                = try(local.module_virtual_wan.disable_vpn_encryption, false)
  er_circuit_connections                = try(local.module_virtual_wan.er_circuit_connections, {})
  expressroute_gateways                 = try(local.module_virtual_wan.expressroute_gateways, {})
  firewalls                             = local.firewalls
  office365_local_breakout_category     = try(local.module_virtual_wan.office365_local_breakout_category, null)
  location                              = var.location
  p2s_gateway_vpn_server_configurations = try(local.module_virtual_wan.p2s_gateway_vpn_server_configurations, {})
  p2s_gateways                          = try(local.module_virtual_wan.p2s_gateways, {})
  resource_group_name                   = var.resource_group_name
  create_resource_group                 = false
  virtual_hubs                          = var.virtual_hubs
  virtual_network_connections           = local.virtual_network_connections
  virtual_wan_name                      = var.name
  type                                  = try(local.module_virtual_wan.type, null)
  routing_intents                       = try(local.module_virtual_wan.routing_intents, null)
  resource_group_tags                   = try(local.module_virtual_wan.resource_group_tags, null)
  virtual_wan_tags                      = try(local.module_virtual_wan.virtual_wan_tags, null)
  vpn_gateways                          = try(local.module_virtual_wan.vpn_gateways, {})
  vpn_site_connections                  = try(local.module_virtual_wan.vpn_site_connections, {})
  vpn_sites                             = try(local.module_virtual_wan.vpn_sites, null)
  tags                                  = try(local.module_virtual_wan.tags, null)
  enable_telemetry                      = var.enable_telemetry

  depends_on = [
    module.management_groups,
    module.virtual_wan_resource_group
  ]
}

module "virtual_network_private_dns" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm"
  version = "0.4.0"

  for_each            = var.private_dns_zones_enabled ? var.virtual_hubs : {}

  address_space       = each.value.private_dns_zones_networking.virtual_network.address_space
  location            = each.value.location
  name                = each.value.private_dns_zones_networking.virtual_network.name
  resource_group_name = each.value.resource_group_name
  enable_telemetry    = var.enable_telemetry
  subnets = {
    dns = {
      address_prefix = each.value.private_dns_zones_networking.virtual_network.private_dns_resolver_subnet.address_prefix
      name           = each.value.private_dns_zones_networking.virtual_network.private_dns_resolver_subnet.name
      delegation = [{
        name = "Microsoft.Network.dnsResolvers"
        service_delegation = {
          name = "Microsoft.Network/dnsResolvers"
          #actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
        }
      }]
    }
  }

  depends_on = [module.virtual_wan_resource_group]
}

module "dns_resolver" {
  source  = "Azure/avm-res-network-dnsresolver/azurerm"
  version = "0.2.1"

  for_each            = var.private_dns_zones_enabled ? var.virtual_hubs : {}

  location                    = each.value.location
  name                        = each.value.private_dns_zones_networking.private_dns_resolver.name
  resource_group_name         = each.value.resource_group_name
  virtual_network_resource_id = module.virtual_network_private_dns[each.key].resource_id
  enable_telemetry            = var.enable_telemetry
  inbound_endpoints = {
    dns = {
      name        = "dns"
      subnet_name = module.virtual_network_private_dns[each.key].subnets.dns.name
    }
  }

  depends_on = [module.virtual_wan_resource_group]
}
