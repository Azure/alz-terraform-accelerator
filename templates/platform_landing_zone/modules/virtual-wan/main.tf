module "firewall_policy" {
  source  = "Azure/avm-res-network-firewallpolicy/azurerm"
  version = "0.3.2"

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
  version = "0.8.0"

  allow_branch_to_branch_traffic        = try(var.virtual_wan_settings.allow_branch_to_branch_traffic, null)
  disable_vpn_encryption                = try(var.virtual_wan_settings.disable_vpn_encryption, false)
  er_circuit_connections                = try(var.virtual_wan_settings.er_circuit_connections, {})
  expressroute_gateways                 = local.virtual_network_gateways_express_route
  firewalls                             = local.firewalls
  office365_local_breakout_category     = try(var.virtual_wan_settings.office365_local_breakout_category, "None")
  location                              = var.virtual_wan_settings.location
  p2s_gateway_vpn_server_configurations = try(var.virtual_wan_settings.p2s_gateway_vpn_server_configurations, {})
  p2s_gateways                          = try(var.virtual_wan_settings.p2s_gateways, {})
  resource_group_name                   = var.virtual_wan_settings.resource_group_name
  create_resource_group                 = false
  virtual_hubs                          = local.virtual_hubs
  virtual_network_connections           = local.virtual_network_connections
  virtual_wan_name                      = var.virtual_wan_settings.name
  type                                  = try(var.virtual_wan_settings.type, "Standard")
  routing_intents                       = try(var.virtual_wan_settings.routing_intents, null)
  resource_group_tags                   = try(var.virtual_wan_settings.resource_group_tags, null)
  virtual_wan_tags                      = try(var.virtual_wan_settings.virtual_wan_tags, null)
  vpn_gateways                          = local.virtual_network_gateways_vpn
  vpn_site_connections                  = try(var.virtual_wan_settings.vpn_site_connections, {})
  vpn_sites                             = try(var.virtual_wan_settings.vpn_sites, {})
  tags                                  = try(var.virtual_wan_settings.tags, null)
  enable_telemetry                      = var.enable_telemetry
}

module "virtual_network_side_car" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm"
  version = "0.7.1"

  for_each = local.side_car_virtual_networks

  address_space        = each.value.address_space
  location             = each.value.location
  name                 = each.value.name
  resource_group_name  = each.value.resource_group_name
  enable_telemetry     = var.enable_telemetry
  tags                 = var.tags
  ddos_protection_plan = each.value.ddos_protection_plan
  subnets              = local.subnets[each.key]
}

module "dns_resolver" {
  source  = "Azure/avm-res-network-dnsresolver/azurerm"
  version = "0.4.0"

  for_each = local.private_dns_zones

  location                    = each.value.location
  name                        = each.value.private_dns_resolver.name
  resource_group_name         = each.value.private_dns_resolver.resource_group_name == null ? local.virtual_hubs[each.key].resource_group : each.value.private_dns_resolver.resource_group_name
  virtual_network_resource_id = module.virtual_network_side_car[each.key].resource_id
  enable_telemetry            = var.enable_telemetry
  tags                        = var.tags
  inbound_endpoints = {
    dns = {
      name        = "dns"
      subnet_name = module.virtual_network_side_car[each.key].subnets["dns_resolver"].name
    }
  }
}

module "private_dns_zones" {
  source  = "Azure/avm-ptn-network-private-link-private-dns-zones/azurerm"
  version = "0.7.1"

  for_each = local.private_dns_zones

  location                                = each.value.location
  resource_group_name                     = each.value.resource_group_name
  resource_group_creation_enabled         = false
  virtual_network_resource_ids_to_link_to = local.private_dns_zones_virtual_network_links
  private_link_private_dns_zones          = each.value.private_link_private_dns_zones == null ? (each.value.is_primary ? null : local.private_dns_zones_secondary_zones) : each.value.private_link_private_dns_zones
  enable_telemetry                        = var.enable_telemetry
  tags                                    = var.tags
}

module "private_dns_zone_auto_registration" {
  source  = "Azure/avm-res-network-privatednszone/azurerm"
  version = "0.2.2"

  for_each = local.private_dns_zones_auto_registration

  resource_group_name = each.value.resource_group_name
  domain_name         = each.value.auto_registration_zone_name

  virtual_network_links = {
    auto_registration = {
      vnetlinkname     = "vnet-link-${each.key}-auto-registration"
      vnetid           = each.value.vnet_resource_id
      autoregistration = true
      tags             = var.tags
    }
  }

  tags = var.tags

  enable_telemetry = var.enable_telemetry
}

module "ddos_protection_plan" {
  source  = "Azure/avm-res-network-ddosprotectionplan/azurerm"
  version = "0.3.0"

  count = local.ddos_protection_plan_enabled ? 1 : 0

  name                = local.ddos_protection_plan.name
  resource_group_name = local.ddos_protection_plan.resource_group_name
  location            = local.ddos_protection_plan.location
  enable_telemetry    = var.enable_telemetry
  tags                = var.tags
}

module "bastion_public_ip" {
  source  = "Azure/avm-res-network-publicipaddress/azurerm"
  version = "0.2.0"

  for_each = local.bastion_host_public_ips

  name                    = try(each.value.name, "pip-bastion-${each.key}")
  resource_group_name     = each.value.resource_group_name
  location                = each.value.location
  allocation_method       = try(each.value.allocation_method, "Static")
  ddos_protection_mode    = try(each.value.ddos_protection_mode, "VirtualNetworkInherited")
  ddos_protection_plan_id = try(each.value.ddos_protection_plan_id, null)
  diagnostic_settings     = try(each.value.diagnostic_settings, null)
  domain_name_label       = try(each.value.domain_name_label, null)
  edge_zone               = try(each.value.edge_zone, null)
  enable_telemetry        = var.enable_telemetry
  idle_timeout_in_minutes = try(each.value.idle_timeout_in_minutes, 4)
  ip_tags                 = try(each.value.ip_tags, null)
  ip_version              = try(each.value.ip_version, "IPv4")
  lock                    = try(each.value.lock, null)
  public_ip_prefix_id     = try(each.value.public_ip_prefix_id, null)
  reverse_fqdn            = try(each.value.reverse_fqdn, null)
  role_assignments        = try(each.value.role_assignments, {})
  sku                     = try(each.value.sku, "Standard")
  sku_tier                = try(each.value.sku_tier, "Regional")
  tags                    = try(each.value.tags, var.tags)
  zones                   = try(each.value.zones, [1, 2, 3])
}

module "bastion_host" {
  source  = "Azure/avm-res-network-bastionhost/azurerm"
  version = "0.4.0"

  for_each = local.bastion_hosts

  name                   = try(each.value.name, "snap-bastion-${each.key}")
  resource_group_name    = each.value.resource_group_name
  location               = each.value.location
  copy_paste_enabled     = try(each.value.copy_paste_enabled, false)
  diagnostic_settings    = try(each.value.diagnostic_settings, null)
  enable_telemetry       = var.enable_telemetry
  file_copy_enabled      = try(each.value.file_copy_enabled, false)
  ip_configuration       = each.value.ip_configuration
  ip_connect_enabled     = try(each.value.ip_connect_enabled, false)
  kerberos_enabled       = try(each.value.kerberos_enabled, false)
  lock                   = try(each.value.lock, null)
  role_assignments       = try(each.value.role_assignments, {})
  scale_units            = try(each.value.scale_units, 2)
  shareable_link_enabled = try(each.value.shareable_link_enabled, false)
  sku                    = try(each.value.sku, "Standard")
  tags                   = try(each.value.tags, var.tags)
  tunneling_enabled      = try(each.value.tunneling_enabled, false)
  virtual_network_id     = try(each.value.virtual_network_id, null)
}
