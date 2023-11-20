locals {
  tenant_root_management_group_id = var.tenant_root_management_group_id == "" ? data.azurerm_client_config.current.tenant_id : var.tenant_root_management_group_id

  base_config_replacements = {
    default_location                = var.default_location
    default_postfix                 = var.default_postfix
    tenant_root_management_group_id = local.tenant_root_management_group_id
    subscription_id_connectivity    = var.subscription_id_connectivity
    subscription_id_identity        = var.subscription_id_identity
    subscription_id_management      = var.subscription_id_management
  }

  raw_config       = yamldecode(file("${path.module}/config.yaml"))
  templated_config = yamldecode(templatefile("${path.module}/config.yaml", local.base_config_replacements))

  management                  = local.templated_config.management
  connectivity = local.templated_config.connectivity

  hub_virtual_networks = {
    for k, v in local.connectivity.hub_networking.hub_virtual_networks : k => {
      for k2, v2 in v : k2 => v2 if k2 != "virtual_network_gateway"
    }
  }
  virtual_network_gateways = {
    for k, v in local.connectivity.hub_networking.hub_virtual_networks : k => merge(
      v.virtual_network_gateway,
      {
        location                            = v.location
        virtual_network_name                = v.name
        virtual_network_resource_group_name = v.resource_group_name
      }
    )
  }
}

output "test" {
  value = {
    management_groups_layer_1 = local.management_groups_layer_1
    management_groups_layer_2 = local.management_groups_layer_2
    management_groups_layer_3 = local.management_groups_layer_3
    management_groups_layer_4 = local.management_groups_layer_4
    management_groups_layer_5 = local.management_groups_layer_5
    management_groups_layer_6 = local.management_groups_layer_6
    management_groups_layer_7 = local.management_groups_layer_7
  }
}
