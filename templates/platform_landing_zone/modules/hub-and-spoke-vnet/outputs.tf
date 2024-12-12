output "dns_server_ip_addresses" {
  value = { for key, value in local.hub_virtual_networks : key => try(value.hub_router_ip_address, try(module.hub_and_spoke_vnet.firewalls[key].private_ip_address, null)) }
}
