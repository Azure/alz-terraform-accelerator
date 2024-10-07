output "yaml" {
  value = yamlencode({
    hub_and_spoke_vnet_es = {
      management_use_avm                  = var.management_use_avm
      management_settings_es              = var.management_settings_es
      connectivity_type                   = var.connectivity_type
      connectivity_resource_groups        = var.connectivity_resource_groups
      hub_and_spoke_vnet_settings         = var.hub_and_spoke_vnet_settings
      hub_and_spoke_vnet_virtual_networks = var.hub_and_spoke_vnet_virtual_networks
    }
  })
}
