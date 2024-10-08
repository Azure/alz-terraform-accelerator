module "management_groups" {
  source  = "Azure/caf-enterprise-scale/azurerm"
  version = "6.1.0"

  disable_telemetry                                       = !var.enable_telemetry
  default_location                                        = var.settings.default_location
  root_parent_id                                          = var.settings.root_parent_id
  archetype_config_overrides                              = try(var.settings.archetype_config_overrides, {})
  configure_connectivity_resources                        = try(var.settings.configure_connectivity_resources, {})
  configure_identity_resources                            = try(var.settings.configure_identity_resources, {})
  configure_management_resources                          = try(var.settings.configure_management_resources, {})
  create_duration_delay                                   = try(var.settings.create_duration_delay, {})
  custom_landing_zones                                    = try(var.settings.custom_landing_zones, {})
  custom_policy_roles                                     = try(var.settings.custom_policy_roles, {})
  default_tags                                            = try(var.settings.default_tags, {})
  deploy_connectivity_resources                           = try(var.settings.deploy_connectivity_resources, false)
  deploy_core_landing_zones                               = try(var.settings.deploy_core_landing_zones, true)
  deploy_corp_landing_zones                               = try(var.settings.deploy_corp_landing_zones, false)
  deploy_demo_landing_zones                               = try(var.settings.deploy_demo_landing_zones, false)
  deploy_diagnostics_for_mg                               = try(var.settings.deploy_diagnostics_for_mg, false)
  deploy_identity_resources                               = try(var.settings.deploy_identity_resources, false)
  deploy_management_resources                             = try(var.settings.deploy_management_resources, false)
  deploy_online_landing_zones                             = try(var.settings.deploy_online_landing_zones, false)
  deploy_sap_landing_zones                                = try(var.settings.deploy_sap_landing_zones, false)
  destroy_duration_delay                                  = try(var.settings.destroy_duration_delay, {})
  disable_base_module_tags                                = try(var.settings.disable_base_module_tags, false)
  library_path                                            = try(var.settings.library_path, "")
  policy_non_compliance_message_default                   = try(var.settings.policy_non_compliance_message_default, "This resource {enforcementMode} be compliant with the assigned policy.")
  policy_non_compliance_message_default_enabled           = try(var.settings.policy_non_compliance_message_default_enabled, true)
  policy_non_compliance_message_enabled                   = try(var.settings.policy_non_compliance_message_enabled, true)
  policy_non_compliance_message_enforced_replacement      = try(var.settings.policy_non_compliance_message_enforced_replacement, "must")
  policy_non_compliance_message_enforcement_placeholder   = try(var.settings.policy_non_compliance_message_enforcement_placeholder, "{enforcementMode}")
  policy_non_compliance_message_not_enforced_replacement  = try(var.settings.policy_non_compliance_message_not_enforced_replacement, "should")
  policy_non_compliance_message_not_supported_definitions = try(var.settings.policy_non_compliance_message_not_supported_definitions, ["/providers/Microsoft.Authorization/policyDefinitions/1c6e92c9-99f0-4e55-9cf2-0c234dc48f99", "/providers/Microsoft.Authorization/policyDefinitions/1a5b4dca-0b6f-4cf5-907c-56316bc1bf3d", "/providers/Microsoft.Authorization/policyDefinitions/95edb821-ddaf-4404-9732-666045e056b4"])
  resource_custom_timeouts                                = try(var.settings.resource_custom_timeouts, {})
  root_id                                                 = try(var.settings.root_id, "alz")
  root_name                                               = try(var.settings.root_name, "Azure-Landing-Zones")
  strict_subscription_association                         = try(var.settings.strict_subscription_association, true)
  subscription_id_connectivity                            = var.settings.subscription_id_connectivity
  subscription_id_identity                                = var.settings.subscription_id_identity
  subscription_id_management                              = var.settings.subscription_id_management
  subscription_id_overrides                               = try(var.settings.subscription_id_overrides, {})
  template_file_variables                                 = try(var.settings.template_file_variables, {})

  providers = {
    azurerm              = azurerm
    azurerm.connectivity = azurerm.connectivity
    azurerm.management   = azurerm.management
  }
}
