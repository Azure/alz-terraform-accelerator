locals {
  bastions_enabled = { for key, value in var.virtual_hubs : key => can(value.bastion) }
}

locals {
  bastion_hosts = {
    for key, value in var.virtual_hubs : key => merge({
      location            = value.hub_virtual_network.location
      resource_group_name = value.hub_virtual_network.resource_group_name
      ip_configuration = {
        name                 = "bastion-ip-config"
        subnet_id            = module.virtual_network_side_car[key].subnet["bastion"].resource_id
        public_ip_address_id = module.bastion_public_ip[key].public_ip_id
      }
    }, value.bastion.bastion_host) if local.bastions_enabled[key]
  }

  bastion_host_public_ips = {
    for key, value in var.virtual_hubs : key => merge({
      location            = value.hub_virtual_network.location
      resource_group_name = value.hub_virtual_network.resource_group_name
    }, value.bastion.bastion_public_ip) if local.bastions_enabled[key]
  }
}