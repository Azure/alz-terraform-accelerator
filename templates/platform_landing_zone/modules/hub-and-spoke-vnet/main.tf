module "hub_and_spoke_vnet" {
  source  = "Azure/avm-ptn-hubnetworking/azurerm"
  version = "0.5.0"

  hub_virtual_networks = local.hub_virtual_networks
  enable_telemetry     = var.enable_telemetry
}

module "virtual_network_gateway" {
  source  = "Azure/avm-ptn-vnetgateway/azurerm"
  version = "0.6.2"

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

module "dns_resolver" {
  source  = "Azure/avm-res-network-dnsresolver/azurerm"
  version = "0.4.0"

  for_each = local.private_dns_zones

  location                    = each.value.location
  name                        = each.value.private_dns_resolver.name
  resource_group_name         = each.value.private_dns_resolver.resource_group_name == null ? local.hub_virtual_networks[each.key].resource_group_name : each.value.private_dns_resolver.resource_group_name
  virtual_network_resource_id = module.hub_and_spoke_vnet.virtual_networks[each.key].id
  enable_telemetry            = var.enable_telemetry
  tags                        = var.tags
  inbound_endpoints = {
    dns = {
      name                         = "dns"
      subnet_name                  = module.hub_and_spoke_vnet.virtual_networks[each.key].subnets["${each.key}-dns_resolver"].name
      private_ip_allocation_method = "Static"
      private_ip_address           = local.private_dns_resolver_ip_addresses[each.key]
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
