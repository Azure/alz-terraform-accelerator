output "dns_server_ip_addresses" {
  value = { for key, value in local.virtual_hubs : key => try(module.virtual_wan.firewall_ip_addresses_by_hub_key[key].private_ip_address, null) }
}
