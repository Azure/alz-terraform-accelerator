output "dns_server_ip_address" {
  value = local.connectivity_enabled ? (local.connectivity_hub_and_spoke_vnet_enabled ? module.hub_and_spoke_vnet[0].dns_server_ip_addresses : module.virtual_wan[0].dns_server_ip_address) : null
}

output "hub_and_spoke_vnet_virtual_network_resource_ids" {
  value = local.connectivity_hub_and_spoke_vnet_enabled ? module.hub_and_spoke_vnet[0].virtual_network_resource_ids : null
}

output "hub_and_spoke_vnet_virtual_network_resource_names" {
  value = local.connectivity_hub_and_spoke_vnet_enabled ? module.hub_and_spoke_vnet[0].virtual_network_resource_names : null
}

output "hub_and_spoke_vnet_firewall_resource_ids" {
  value = local.connectivity_hub_and_spoke_vnet_enabled ? module.hub_and_spoke_vnet[0].firewall_resource_ids : null
}

output "hub_and_spoke_vnet_firewall_resource_names" {
  value = local.connectivity_hub_and_spoke_vnet_enabled ? module.hub_and_spoke_vnet[0].firewall_resource_names : null
}

output "hub_and_spoke_vnet_firewall_private_ip_address" {
  value = local.connectivity_hub_and_spoke_vnet_enabled ? module.hub_and_spoke_vnet[0].firewall_private_ip_addresses : null
}

output "hub_and_spoke_vnet_firewall_public_ip_addresses" {
  value = local.connectivity_hub_and_spoke_vnet_enabled ? module.hub_and_spoke_vnet[0].firewall_public_ip_addresses : null
}

output "hub_and_spoke_vnet_firewall_policy_ids" {
  value = local.connectivity_hub_and_spoke_vnet_enabled ? module.hub_and_spoke_vnet[0].firewall_policy_ids : null
}

output "hub_and_spoke_vnet_route_tables_firewall" {
  value = local.connectivity_hub_and_spoke_vnet_enabled ? module.hub_and_spoke_vnet[0].route_tables_firewall : null
}

output "hub_and_spoke_vnet_route_tables_user_subnets" {
  value = local.connectivity_hub_and_spoke_vnet_enabled ? module.hub_and_spoke_vnet[0].route_tables_user_subnets : null
}

output "hub_and_spoke_vnet_full_output" {
  value = local.connectivity_hub_and_spoke_vnet_enabled ? module.hub_and_spoke_vnet[0] : null
}

output "virtual_wan_resource_id" {
  value = local.connectivity_virtual_wan_enabled ? module.virtual_wan[0].resource_id : null
}

output "virtual_wan_name" {
  value = local.connectivity_virtual_wan_enabled ? module.virtual_wan[0].name : null
}

output "virtual_wan_virtual_hub_resource_ids" {
  value = local.connectivity_virtual_wan_enabled ? module.virtual_wan[0].virtual_hub_resource_ids : null
}

output "virtual_wan_virtual_hub_resource_names" {
  value = local.connectivity_virtual_wan_enabled ? module.virtual_wan[0].virtual_hub_resource_names : null
}

output "virtual_wan_firewall_resource_ids" {
  value = local.connectivity_virtual_wan_enabled ? module.virtual_wan[0].firewall_resource_ids : null
}

output "virtual_wan_firewall_resource_names" {
  value = local.connectivity_virtual_wan_enabled ? module.virtual_wan[0].firewall_resource_names : null
}

output "virtual_wan_firewall_private_ip_address" {
  value = local.connectivity_virtual_wan_enabled ? module.virtual_wan[0].firewall_private_ip_address : null
}

output "virtual_wan_firewall_public_ip_addresses" {
  value = local.connectivity_virtual_wan_enabled ? module.virtual_wan[0].firewall_public_ip_addresses : null
}

output "virtual_wan_firewall_policy_ids" {
  value = local.connectivity_virtual_wan_enabled ? module.virtual_wan[0].firewall_policy_resource_ids : null
}

output "virtual_wan_express_route_gateway_resource_ids" {
  value = local.connectivity_virtual_wan_enabled ? module.virtual_wan[0].express_route_gateway_resource_ids : null
}

output "virtual_wan_bastion_host_public_ip_address" {
  value = local.connectivity_virtual_wan_enabled ? module.virtual_wan[0].bastion_host_public_ip_address : null
}

output "virtual_wan_bastion_host_resource_ids" {
  value = local.connectivity_virtual_wan_enabled ? module.virtual_wan[0].bastion_host_resource_ids : null
}

output "virtual_wan_bastion_host_resources" {
  value = local.connectivity_virtual_wan_enabled ? module.virtual_wan[0].bastion_host_resources : null
}

output "virtual_wan_private_dns_resolver_resource_ids" {
  value = local.connectivity_virtual_wan_enabled ? module.virtual_wan[0].private_dns_resolver_resource_ids : null
}

output "virtual_wan_private_dns_resolver_resources" {
  value = local.connectivity_virtual_wan_enabled ? module.virtual_wan[0].private_dns_resolver_resources : null
}

output "virtual_wan_sidecar_virtual_network_resource_ids" {
  value = local.connectivity_virtual_wan_enabled ? module.virtual_wan[0].sidecar_virtual_network_resource_ids : null
}

output "virtual_wan_sidecar_virtual_network_resources" {
  value = local.connectivity_virtual_wan_enabled ? module.virtual_wan[0].sidecar_virtual_network_resources : null
}

output "virtual_wan_full_output" {
  value = local.connectivity_virtual_wan_enabled ? module.virtual_wan[0] : null
}

output "templated_inputs" {
  value = module.config
}
