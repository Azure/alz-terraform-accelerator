module "enterprise_scale" {
  source  = "Azure/caf-enterprise-scale/azurerm"
  version = "~> 6.0.0"

  count = length(local.archetypes) > 0 ? 1 : 0

  disable_telemetry                                       = try(local.archetypes.disable_telemetry, true)
  default_location                                        = try(local.archetypes.default_location, local.starter_location)
  root_parent_id                                          = try(local.archetypes.root_parent_id, data.azurerm_client_config.core.tenant_id)
  archetype_config_overrides                              = try(local.archetypes.archetype_config_overrides, {})
  configure_connectivity_resources                        = try(local.archetypes.configure_connectivity_resources, {})
  configure_identity_resources                            = try(local.archetypes.configure_identity_resources, {})
  configure_management_resources                          = try(local.archetypes.configure_management_resources, {})
  create_duration_delay                                   = try(local.archetypes.create_duration_delay, {})
  custom_landing_zones                                    = try(local.archetypes.custom_landing_zones, {})
  custom_policy_roles                                     = try(local.archetypes.custom_policy_roles, {})
  default_tags                                            = try(local.archetypes.default_tags, {})
  deploy_connectivity_resources                           = try(local.archetypes.deploy_connectivity_resources, false)
  deploy_core_landing_zones                               = try(local.archetypes.deploy_core_landing_zones, true)
  deploy_corp_landing_zones                               = try(local.archetypes.deploy_corp_landing_zones, false)
  deploy_demo_landing_zones                               = try(local.archetypes.deploy_demo_landing_zones, false)
  deploy_diagnostics_for_mg                               = try(local.archetypes.deploy_diagnostics_for_mg, false)
  deploy_identity_resources                               = try(local.archetypes.deploy_identity_resources, false)
  deploy_management_resources                             = try(local.archetypes.deploy_management_resources, false)
  deploy_online_landing_zones                             = try(local.archetypes.deploy_online_landing_zones, false)
  deploy_sap_landing_zones                                = try(local.archetypes.deploy_sap_landing_zones, false)
  destroy_duration_delay                                  = try(local.archetypes.destroy_duration_delay, {})
  disable_base_module_tags                                = try(local.archetypes.disable_base_module_tags, false)
  library_path                                            = try(local.archetypes.library_path, "")
  policy_non_compliance_message_default                   = try(local.archetypes.policy_non_compliance_message_default, "This resource {enforcementMode} be compliant with the assigned policy.")
  policy_non_compliance_message_default_enabled           = try(local.archetypes.policy_non_compliance_message_default_enabled, true)
  policy_non_compliance_message_enabled                   = try(local.archetypes.policy_non_compliance_message_enabled, true)
  policy_non_compliance_message_enforced_replacement      = try(local.archetypes.policy_non_compliance_message_enforced_replacement, "must")
  policy_non_compliance_message_enforcement_placeholder   = try(local.archetypes.policy_non_compliance_message_enforcement_placeholder, "{enforcementMode}")
  policy_non_compliance_message_not_enforced_replacement  = try(local.archetypes.policy_non_compliance_message_not_enforced_replacement, "should")
  policy_non_compliance_message_not_supported_definitions = try(local.archetypes.policy_non_compliance_message_not_supported_definitions, ["/providers/Microsoft.Authorization/policyDefinitions/1c6e92c9-99f0-4e55-9cf2-0c234dc48f99", "/providers/Microsoft.Authorization/policyDefinitions/1a5b4dca-0b6f-4cf5-907c-56316bc1bf3d", "/providers/Microsoft.Authorization/policyDefinitions/95edb821-ddaf-4404-9732-666045e056b4"])
  resource_custom_timeouts                                = try(local.archetypes.resource_custom_timeouts, {})
  root_id                                                 = try(local.archetypes.root_id, "es")
  root_name                                               = try(local.archetypes.root_name, "Enterprise-Scale")
  strict_subscription_association                         = try(local.archetypes.strict_subscription_association, true)
  subscription_id_connectivity                            = try(local.archetypes.subscription_id_connectivity, var.subscription_id_connectivity)
  subscription_id_identity                                = try(local.archetypes.subscription_id_identity, var.subscription_id_identity)
  subscription_id_management                              = try(local.archetypes.subscription_id_management, var.subscription_id_management)
  subscription_id_overrides                               = try(local.archetypes.subscription_id_overrides, {})
  template_file_variables                                 = try(local.archetypes.template_file_variables, {})

  providers = {
    azurerm              = azurerm
    azurerm.connectivity = azurerm.connectivity
    azurerm.management   = azurerm.management
  }
}

module "hubnetworking" {
  source  = "Azure/hubnetworking/azurerm"
  version = "~> 1.1.0"

  count = length(local.hub_virtual_networks) > 0 ? 1 : 0

  hub_virtual_networks = local.module_hubnetworking.hub_virtual_networks

  providers = {
    azurerm = azurerm.connectivity
  }

  depends_on = [
    module.enterprise_scale
  ]
}

module "virtual_network_gateway" {
  source  = "Azure/avm-ptn-vnetgateway/azurerm"
  version = "~> 0.3.0"

  for_each = local.module_virtual_network_gateway

  location                                  = each.value.location
  name                                      = each.value.name
  sku                                       = try(each.value.sku, null)
  type                                      = try(each.value.type, null)
  virtual_network_id                        = each.value.virtual_network_id
  default_tags                              = try(each.value.default_tags, null)
  subnet_creation_enabled                   = try(each.value.subnet_creation_enabled, null)
  edge_zone                                 = try(each.value.edge_zone, null)
  enable_telemetry                          = false
  express_route_circuits                    = try(each.value.express_route_circuits, null)
  ip_configurations                         = try(each.value.ip_configurations, null)
  local_network_gateways                    = try(each.value.local_network_gateways, null)
  subnet_address_prefix                     = try(each.value.subnet_address_prefix, null)
  tags                                      = try(each.value.tags, null)
  vpn_active_active_enabled                 = try(each.value.vpn_active_active_enabled, null)
  vpn_bgp_enabled                           = try(each.value.vpn_bgp_enabled, null)
  vpn_bgp_settings                          = try(each.value.vpn_bgp_settings, null)
  vpn_generation                            = try(each.value.vpn_generation, null)
  vpn_point_to_site                         = try(each.value.vpn_point_to_site, null)
  vpn_type                                  = try(each.value.vpn_type, null)
  vpn_private_ip_address_enabled            = try(each.value.vpn_private_ip_address_enabled, null)
  route_table_bgp_route_propagation_enabled = try(each.value.route_table_bgp_route_propagation_enabled, null)
  route_table_creation_enabled              = try(each.value.route_table_creation_enabled, null)
  route_table_name                          = try(each.value.route_table_name, null)
  route_table_tags                          = try(each.value.route_table_tags, null)

  providers = {
    azurerm = azurerm.connectivity
  }
}

module "vwan" {
  source  = "Azure/avm-ptn-virtualwan/azurerm"
  version = "~> 0.5.0"

  count = length(local.module_vwan) > 0 ? 1 : 0

  allow_branch_to_branch_traffic        = try(local.module_vwan.allow_branch_to_branch_traffic, null)
  create_resource_group                 = try(local.module_vwan.create_resource_group, null)
  disable_vpn_encryption                = try(local.module_vwan.disable_vpn_encryption, null)
  enable_telemetry                      = try(local.module_vwan.enable_telemetry, null)
  er_circuit_connections                = try(local.module_vwan.er_circuit_connections, null)
  expressroute_gateways                 = try(local.module_vwan.expressroute_gateways, null)
  firewalls                             = try(local.module_vwan.firewalls, null)
  office365_local_breakout_category     = try(local.module_vwan.office365_local_breakout_category, null)
  location                              = try(local.module_vwan.location, null)
  p2s_gateway_vpn_server_configurations = try(local.module_vwan.p2s_gateway_vpn_server_configurations, null)
  p2s_gateways                          = try(local.module_vwan.p2s_gateways, null)
  resource_group_name                   = try(local.module_vwan.resource_group_name, null)
  virtual_hubs                          = try(local.module_vwan.virtual_hubs, null)
  virtual_network_connections           = try(local.module_vwan.virtual_network_connections, null)
  virtual_wan_name                      = try(local.module_vwan.virtual_wan_name, null)
  type                                  = try(local.module_vwan.type, null)
  routing_intents                       = try(local.module_vwan.routing_intents, null)
  resource_group_tags                   = try(local.module_vwan.resource_group_tags, null)
  virtual_wan_tags                      = try(local.module_vwan.virtual_wan_tags, null)
  vpn_gateways                          = try(local.module_vwan.vpn_gateways, null)
  vpn_site_connections                  = try(local.module_vwan.vpn_site_connections, null)
  vpn_sites                             = try(local.module_vwan.vpn_sites, null)
  tags                                  = try(local.module_vwan.tags, null)

  providers = {
    azurerm = azurerm.connectivity
  }

  depends_on = [
    module.enterprise_scale
  ]
}
