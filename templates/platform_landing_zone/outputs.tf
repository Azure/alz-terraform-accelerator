output "dns_server_ip_addresses" {
  value = var.connectivity_type == "none" ? {} : (var.connectivity_type == "hub-and-spoke" ? module.hub_and_spoke_vnet.dns_server_ip_addresses : module.virtual_wan.dns_server_ip_addresses)
}
