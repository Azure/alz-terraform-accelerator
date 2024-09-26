module "management_groups" {
  source  = "Azure/caf-enterprise-scale/azurerm"
  version = "6.1.0"

  count = local.management_groups_enabled ? 1 : 0

  disable_telemetry                                       = try(local.management_groups.disable_telemetry, !local.enable_telemetry)
  default_location                                        = try(local.management_groups.default_location, var.starter_locations[0])
  root_parent_id                                          = try(local.management_groups.root_parent_id, data.azurerm_client_config.current.tenant_id)
  archetype_config_overrides                              = try(local.management_groups.archetype_config_overrides, {})
  configure_connectivity_resources                        = try(local.management_groups.configure_connectivity_resources, {})
  configure_identity_resources                            = try(local.management_groups.configure_identity_resources, {})
  configure_management_resources                          = try(local.management_groups.configure_management_resources, {})
  create_duration_delay                                   = try(local.management_groups.create_duration_delay, {})
  custom_landing_zones                                    = try(local.management_groups.custom_landing_zones, {})
  custom_policy_roles                                     = try(local.management_groups.custom_policy_roles, {})
  default_tags                                            = try(local.management_groups.default_tags, {})
  deploy_connectivity_resources                           = try(local.management_groups.deploy_connectivity_resources, true)
  deploy_core_landing_zones                               = try(local.management_groups.deploy_core_landing_zones, true)
  deploy_corp_landing_zones                               = try(local.management_groups.deploy_corp_landing_zones, false)
  deploy_demo_landing_zones                               = try(local.management_groups.deploy_demo_landing_zones, false)
  deploy_diagnostics_for_mg                               = try(local.management_groups.deploy_diagnostics_for_mg, false)
  deploy_identity_resources                               = try(local.management_groups.deploy_identity_resources, false)
  deploy_management_resources                             = try(local.management_groups.deploy_management_resources, false)
  deploy_online_landing_zones                             = try(local.management_groups.deploy_online_landing_zones, false)
  deploy_sap_landing_zones                                = try(local.management_groups.deploy_sap_landing_zones, false)
  destroy_duration_delay                                  = try(local.management_groups.destroy_duration_delay, {})
  disable_base_module_tags                                = try(local.management_groups.disable_base_module_tags, false)
  library_path                                            = try(local.management_groups.library_path, "")
  policy_non_compliance_message_default                   = try(local.management_groups.policy_non_compliance_message_default, "This resource {enforcementMode} be compliant with the assigned policy.")
  policy_non_compliance_message_default_enabled           = try(local.management_groups.policy_non_compliance_message_default_enabled, true)
  policy_non_compliance_message_enabled                   = try(local.management_groups.policy_non_compliance_message_enabled, true)
  policy_non_compliance_message_enforced_replacement      = try(local.management_groups.policy_non_compliance_message_enforced_replacement, "must")
  policy_non_compliance_message_enforcement_placeholder   = try(local.management_groups.policy_non_compliance_message_enforcement_placeholder, "{enforcementMode}")
  policy_non_compliance_message_not_enforced_replacement  = try(local.management_groups.policy_non_compliance_message_not_enforced_replacement, "should")
  policy_non_compliance_message_not_supported_definitions = try(local.management_groups.policy_non_compliance_message_not_supported_definitions, ["/providers/Microsoft.Authorization/policyDefinitions/1c6e92c9-99f0-4e55-9cf2-0c234dc48f99", "/providers/Microsoft.Authorization/policyDefinitions/1a5b4dca-0b6f-4cf5-907c-56316bc1bf3d", "/providers/Microsoft.Authorization/policyDefinitions/95edb821-ddaf-4404-9732-666045e056b4"])
  resource_custom_timeouts                                = try(local.management_groups.resource_custom_timeouts, {})
  root_id                                                 = try(local.management_groups.root_id, "es")
  root_name                                               = try(local.management_groups.root_name, "Enterprise-Scale")
  strict_subscription_association                         = try(local.management_groups.strict_subscription_association, true)
  subscription_id_connectivity                            = try(local.management_groups.subscription_id_connectivity, var.subscription_id_connectivity)
  subscription_id_identity                                = try(local.management_groups.subscription_id_identity, var.subscription_id_identity)
  subscription_id_management                              = try(local.management_groups.subscription_id_management, var.subscription_id_management)
  subscription_id_overrides                               = try(local.management_groups.subscription_id_overrides, {})
  template_file_variables                                 = try(local.management_groups.template_file_variables, {})

  providers = {
    azurerm              = azurerm
    azurerm.connectivity = azurerm.connectivity
    azurerm.management   = azurerm.management
  }
}
