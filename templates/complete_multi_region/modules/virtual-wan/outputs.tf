output "private_dns_zones_virtual_networks" {
  value = {
    for key, value in module.virtual_network_private_dns : key => {
      resource_id = value.resource_id
    }
  }
}