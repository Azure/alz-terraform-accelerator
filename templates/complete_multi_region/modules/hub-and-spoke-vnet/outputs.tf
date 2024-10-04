output "virtual_networks" {
  value = {
    for key, value in module.module.hub_and_spoke_vnet.virtual_networks : key => {
      resource_id = value.id
    }
  }
}
