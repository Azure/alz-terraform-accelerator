output "dns_server_ip_addresses" {
  value = module.virtual_wan.firewall_private_ip_addresses_by_hub_key
}

output "resource_id" {
  value = module.virtual_wan.resource_id
}

output "name" {
  value = module.virtual_wan.name
}

output "virtual_hub_resource_ids" {
  value = module.virtual_wan.virtual_hub_resource_ids
}

output "virtual_hub_resource_names" {
  value = module.virtual_wan.virtual_hub_resource_names
}

output "firewall_resource_ids" {
  value = module.virtual_wan.firewall_resource_ids_by_hub_key
}

output "firewall_resource_names" {
  value = module.virtual_wan.firewall_resource_names_by_hub_key
}

output "firewall_private_ip_addresses" {
  value = module.virtual_wan.firewall_private_ip_addresses_by_hub_key
}

output "firewall_public_ip_addresses" {
  value = module.virtual_wan.firewall_public_ip_addresses_by_hub_key
}

output "firewall_policy_resource_ids" {
  value = { for key, value in module.firewall_policy : key => value.resource_id }
}
