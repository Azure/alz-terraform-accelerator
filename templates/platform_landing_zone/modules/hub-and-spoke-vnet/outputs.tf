output "dns_server_ip_addresses" {
  value = { for key, value in local.hub_virtual_networks : key => try(value.hub_router_ip_address, try(module.hub_and_spoke_vnet.firewalls[key].private_ip_address, null)) }
}

output "virtual_network_resource_ids" {
  value = { for key, value in module.hub_and_spoke_vnet.virtual_networks : key => value.id }
}

output "virtual_network_resource_names" {
  value = { for key, value in module.hub_and_spoke_vnet.virtual_networks : key => value.name }
}

output "firewall_resource_ids" {
  value = { for key, value in module.hub_and_spoke_vnet.firewalls : key => value.id }
}

output "firewall_resource_names" {
  value = { for key, value in module.hub_and_spoke_vnet.firewalls : key => value.name }
}

output "firewall_private_ip_addresses" {
  value = { for key, value in module.hub_and_spoke_vnet.firewalls : key => value.private_ip_address }
}

output "firewall_public_ip_addresses" {
  value = { for key, value in module.hub_and_spoke_vnet.firewalls : key => value.public_ip_address }
}

output "firewall_policy_ids" {
  value = { for key, value in var.hub_virtual_networks.hub : key => try(value.hub_virtual_network.firewall_policy_id, "ToDo") }
}

output "route_tables_firewall" {
  value = module.hub_and_spoke_vnet.hub_route_tables_firewall
}

output "route_tables_user_subnets" {
  value = module.hub_and_spoke_vnet.hub_route_tables_user_subnets
}
