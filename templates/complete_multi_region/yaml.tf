locals {
  yaml_file_header = <<YAML
# This file contains templated variables to avoid repeating the same hard-coded values.
# Templated variables are denoted by the dollar curly braces token (e.g. $${starter_location_01}). The following details each templated variable that you can use:
# `starter_location_01`: This the primary an Azure location sourced from the `starter_locations` variable. This can be used to set the location of resources.
# `starter_location_02` to `starter_location_10`: These are the secondary Azure locations sourced from the `starter_locations` variable. This can be used to set the location of resources.
# `starter_location_01_availability_zones` to `starter_location_10_availability_zones`: These are the availability zones for the Azure locations sourced from the `starter_locations` variable. This can be used to set the availability zones of resources.
# `starter_location_01_virtual_network_gateway_sku_express_route` to `starter_location_10_virtual_network_gateway_sku_express_route`: These are the default SKUs for the Express Route virtual network gateways based on the Azure locations sourced from the `starter_locations` variable. This can be used to set the SKU of the virtual network gateways.
# `starter_location_01_virtual_network_gateway_sku_vpn` to `starter_location_10_virtual_network_gateway_sku_vpn`: These are the default SKUs for the VPN virtual network gateways based on the Azure locations sourced from the `starter_locations` variable. This can be used to set the SKU of the virtual network gateways.
# `root_parent_management_group_id`: This is the id of the management group that the ALZ hierarchy will be nested under.
# `subscription_id_identity`: The subscription ID of the subscription to deploy the identity resources to, sourced from the variable `subscription_id_identity`.
# `subscription_id_connectivity`: The subscription ID of the subscription to deploy the connectivity resources to, sourced from the variable `subscription_id_connectivity`.
# `subscription_id_management`: The subscription ID of the subscription to deploy the management resources to, sourced from the variable `subscription_id_management`.

---
YAML

  yaml_file_hub_and_spoke_vnet_es = yamlencode({
    management_use_avm                  = var.management_use_avm
    management_settings_es              = var.management_settings_es
    connectivity_type                   = var.connectivity_type
    connectivity_resource_groups        = var.connectivity_resource_groups
    hub_and_spoke_vnet_settings         = var.hub_and_spoke_vnet_settings
    hub_and_spoke_vnet_virtual_networks = var.hub_and_spoke_vnet_virtual_networks
  })

  yaml_file_virtual_wan_es = yamlencode({
    management_use_avm           = var.management_use_avm
    management_settings_es       = var.management_settings_es
    connectivity_type            = var.connectivity_type
    connectivity_resource_groups = var.connectivity_resource_groups
    virtual_wan_settings         = var.virtual_wan_settings
    virtual_wan_virtual_hubs     = var.virtual_wan_virtual_hubs
  })

  yaml_file_content = local.connectivity_hub_and_spoke_vnet_enabled ? local.yaml_file_hub_and_spoke_vnet_es : local.yaml_file_virtual_wan_es
  yaml_file_final   = replace(replace("${local.yaml_file_header}${local.yaml_file_content}", "\"", ""), "  - ", "    - ")

  yaml_file_name = "config-${replace(var.connectivity_type, "_", "-")}-multi-region.yaml"
}

resource "local_file" "yaml" {
  content  = local.yaml_file_final
  filename = "${path.module}/examples/${local.yaml_file_name}"
}
