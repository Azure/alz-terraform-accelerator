module "firewall_policy" {
  source  = "Azure/avm-res-network-firewallpolicy/azurerm"
  version = "0.2.3"

  for_each = local.firewall_policies

  name                                              = each.value.name
  location                                          = each.value.location
  resource_group_name                               = each.value.resource_group_name
  firewall_policy_sku                               = try(each.value.sku, "Standard")
  firewall_policy_auto_learn_private_ranges_enabled = try(each.value.auto_learn_private_ranges_enabled, null)
  firewall_policy_base_policy_id                    = try(each.value.base_policy_id, null)
  firewall_policy_dns                               = each.value.dns
  firewall_policy_threat_intelligence_mode          = try(each.value.threat_intelligence_mode, "Alert")
  firewall_policy_private_ip_ranges                 = try(each.value.private_ip_ranges, null)
  firewall_policy_threat_intelligence_allowlist     = try(each.value.threat_intelligence_allowlist, null)
  tags                                              = try(each.value.tags, null)
  enable_telemetry                                  = var.enable_telemetry
}

module "virtual_wan" {
  source  = "Azure/avm-ptn-virtualwan/azurerm"
  version = "0.5.0"

  allow_branch_to_branch_traffic        = try(var.virtual_wan_settings.allow_branch_to_branch_traffic, null)
  disable_vpn_encryption                = try(var.virtual_wan_settings.disable_vpn_encryption, false)
  er_circuit_connections                = try(var.virtual_wan_settings.er_circuit_connections, {})
  expressroute_gateways                 = try(var.virtual_wan_settings.expressroute_gateways, {})
  firewalls                             = local.firewalls
  office365_local_breakout_category     = try(var.virtual_wan_settings.office365_local_breakout_category, null)
  location                              = var.virtual_wan_settings.location
  p2s_gateway_vpn_server_configurations = try(var.virtual_wan_settings.p2s_gateway_vpn_server_configurations, {})
  p2s_gateways                          = try(var.virtual_wan_settings.p2s_gateways, {})
  resource_group_name                   = var.virtual_wan_settings.resource_group_name
  create_resource_group                 = false
  virtual_hubs                          = local.virtual_hubs
  virtual_network_connections           = local.virtual_network_connections
  virtual_wan_name                      = var.virtual_wan_settings.name
  type                                  = try(var.virtual_wan_settings.type, null)
  routing_intents                       = try(var.virtual_wan_settings.routing_intents, null)
  resource_group_tags                   = try(var.virtual_wan_settings.resource_group_tags, null)
  virtual_wan_tags                      = try(var.virtual_wan_settings.virtual_wan_tags, null)
  vpn_gateways                          = try(var.virtual_wan_settings.vpn_gateways, {})
  vpn_site_connections                  = try(var.virtual_wan_settings.vpn_site_connections, {})
  vpn_sites                             = try(var.virtual_wan_settings.vpn_sites, null)
  tags                                  = try(var.virtual_wan_settings.tags, null)
  enable_telemetry                      = var.enable_telemetry
}

module "virtual_network_private_dns" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm"
  version = "0.4.0"

  for_each = local.private_dns_zones

  address_space       = [each.value.networking.virtual_network.address_space]
  location            = each.value.location
  name                = each.value.networking.virtual_network.name
  resource_group_name = each.value.networking.virtual_network.resource_group_name
  enable_telemetry    = var.enable_telemetry
  tags                = var.tags
  ddos_protection_plan = local.ddos_protection_plan_enabled ? {
    id     = module.ddos_protection_plan[0].resource.id
    enable = true
  } : null
  subnets = {
    dns = {
      address_prefix = each.value.networking.virtual_network.private_dns_resolver_subnet.address_prefix
      name           = each.value.networking.virtual_network.private_dns_resolver_subnet.name
      delegation = [{
        name = "Microsoft.Network.dnsResolvers"
        service_delegation = {
          name = "Microsoft.Network/dnsResolvers"
          #actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
        }
      }]
    }
  }
}

module "dns_resolver" {
  source  = "Azure/avm-res-network-dnsresolver/azurerm"
  version = "0.2.1"

  for_each = local.private_dns_zones

  location                    = each.value.location
  name                        = each.value.networking.private_dns_resolver.name
  resource_group_name         = each.value.networking.private_dns_resolver.resource_group_name
  virtual_network_resource_id = module.virtual_network_private_dns[each.key].resource_id
  enable_telemetry            = var.enable_telemetry
  tags                        = var.tags
  inbound_endpoints = {
    dns = {
      name        = "dns"
      subnet_name = module.virtual_network_private_dns[each.key].subnets.dns.name
    }
  }
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
