output "dns_server_ip_addresses" {
  value = local.connectivity_enabled ? (local.connectivity_hub_and_spoke_vnet_enabled ? module.hub_and_spoke_vnet[0].dns_server_ip_addresses : module.virtual_wan[0].dns_server_ip_addresses) : {}
}

output "hub_and_spoke_vnet_virtual_networks" {
  value = local.connectivity_hub_and_spoke_vnet_enabled ? module.hub_and_spoke_vnet[0].virtual_networks : {}
}

output "hub_and_spoke_vnet_firewalls" {
  value = local.connectivity_hub_and_spoke_vnet_enabled ? module.hub_and_spoke_vnet[0].firewalls : {}
}

output "hub_and_spoke_vnet_route_tables_firewall" {
  value = local.connectivity_hub_and_spoke_vnet_enabled ? module.hub_and_spoke_vnet[0].route_tables_firewall : {}
}

output "hub_and_spoke_vnet_route_tables_user_subnets" {
  value = local.connectivity_hub_and_spoke_vnet_enabled ? module.hub_and_spoke_vnet[0].route_tables_user_subnets : {}
}

output "virtual_wan_virtual_hubs" {
  value = local.connectivity_virtual_wan_enabled ? module.virtual_wan[0].virtual_hubs : {}
}

output "virtual_wan_firewall_policy_ids" {
  value = local.connectivity_virtual_wan_enabled ? module.virtual_wan[0].firewall_policy_ids : {}
}
