// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.
/*
SUMMARY : This file contains the main for the Cloud for Financial Services
AUTHOR/S: Cloud for Financial Services
*/
module "bootstrap" {
  source = "../modules/bootstrap"

  subscription_billing_scope              = var.subscription_billing_scope
  root_parent_management_group_id         = local.root_parent_management_group_id
  architecture_name                       = local.architecture_name
  location                                = local.default_location
  default_prefix                          = var.default_prefix
  default_postfix                         = var.default_postfix
  enable_telemetry                        = var.enable_telemetry
  partner_id_uuid                         = local.partner_id_uuid
  landing_zone_management_group_children  = var.landing_zone_management_group_children
  subscription_id_connectivity            = var.subscription_id_connectivity
  subscription_id_identity                = var.subscription_id_identity
  subscription_id_management              = var.subscription_id_management
  policy_default_values                   = local.fsi_policy_default_values
  tenant_id                               = local.tenant_id
  management_group_top_level_display_name = local.management_group_top_level_display_name
}

module "compliance" {
  source = "../modules/compliance"

  location                           = local.default_location
  policy_assignment_enforcement_mode = var.policy_assignment_enforcement_mode
  customer_policy_sets               = var.customer_policy_sets

  depends_on = [module.bootstrap]
}

module "dashboard" {
  source = "../modules/dashboard"

  location                   = local.default_location
  default_prefix             = var.default_prefix
  default_postfix            = var.default_postfix
  enable_telemetry           = var.enable_telemetry
  customer                   = var.customer
  subscription_id_management = local.subscription_id_management
  dashboard_name             = local.dashboard_name

  depends_on = [module.bootstrap]

  providers = {
    azurerm = azurerm.management
  }
}

module "platform" {
  source = "../modules/platform"

  location                                  = local.default_location
  default_prefix                            = var.default_prefix
  default_postfix                           = var.default_postfix
  deploy_log_analytics_workspace            = var.deploy_log_analytics_workspace
  enable_telemetry                          = var.enable_telemetry
  log_analytics_workspace_retention_in_days = var.log_analytics_workspace_retention_in_days
  log_analytics_solution_plans              = local.log_analytics_workspace_solutions
  tags                                      = var.tags
  deploy_hub_network                        = var.deploy_hub_network
  enable_firewall                           = var.enable_firewall
  deploy_ddos_protection                    = var.deploy_ddos_protection
  use_premium_firewall                      = var.use_premium_firewall
  hub_network_address_prefix                = var.hub_network_address_prefix
  custom_subnets                            = var.custom_subnets
  az_firewall_policies_enabled              = var.az_firewall_policies_enabled
  express_route_gateway_config              = var.express_route_gateway_config
  deploy_bastion                            = var.deploy_bastion
  subscription_id_connectivity              = local.subscription_id_connectivity
  vpn_gateway_config                        = var.vpn_gateway_config
  bastion_outbound_ssh_rdp_ports            = var.bastion_outbound_ssh_rdp_ports

  providers = {
    azurerm.connectivity = azurerm.connectivity
    azurerm.management   = azurerm.management
  }
}

module "policy_exemption" {
  source = "../modules/policy_exemption"

  policy_exemptions = local.policy_exemptions

  depends_on = [module.bootstrap, module.compliance]
}

module "policy_remediation" {
  source = "../modules/policy_remediation"

  policy_assignment_resource_ids        = module.bootstrap.policy_assignment_resource_ids
  policy_set_definition_name_exclusions = local.policy_set_definition_name

  depends_on = [module.bootstrap, module.compliance, module.policy_exemption]
}