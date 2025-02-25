output "dns_server_ip_addresses" {
  value = { for key, value in local.hub_virtual_networks : key => try(value.hub_router_ip_address, try(module.hub_and_spoke_vnet.firewalls[key].private_ip_address, null)) }
}

output "virtual_networks" {
  value = module.hub_and_spoke_vnet.virtual_networks
}

output "firewalls" {
  value = module.hub_and_spoke_vnet.firewalls
}

output "route_tables_firewall" {
  value = module.hub_and_spoke_vnet.hub_route_tables_firewall
}

output "route_tables_user_subnets" {
  value = module.hub_and_spoke_vnet.hub_route_tables_user_subnets
}
