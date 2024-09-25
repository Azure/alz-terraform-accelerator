# output "transformed_config_file" {
#   value = local.config_file_content
# }

output "firewall_ip_addresses" {
  value = (local.hub_networking_enabled ?
    { for key, value in try(module.hub_and_spoke_vnet[0].firewalls, {}) : key => value.private_ip_address } :
    (local.virtual_wan_enabled ?
      { for key, value in try(module.virtual_wan[0].fw, {}) : key => value.name } : {}
    )
  ) # TODO: Output vWAN firewall IP addresses
}
