output "connectivity_resource_groups" {
  value = local.connectivity_resource_groups
}

output "management_resource_settings" {
  value = local.management_resource_settings
}

output "management_group_settings" {
  value = local.management_group_settings
}

output "hub_and_spoke_vnet_settings" {
  value = local.hub_and_spoke_vnet_settings
}

output "hub_and_spoke_vnet_virtual_networks" {
  value = local.hub_and_spoke_vnet_virtual_networks
}

output "virtual_wan_settings" {
  value = local.virtual_wan_settings
}

output "virtual_wan_virtual_hubs" {
  value = local.virtual_wan_virtual_hubs
}

output "tags" {
  value = local.tags
}

output "custom_replacements" {
  value = local.final_replacements
}
