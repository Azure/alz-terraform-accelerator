// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.
/*
SUMMARY : This file contains the main for the Sovereign Landing Zone
AUTHOR/S: Cloud for Sovereignty
*/
module "bootstrap" {
  count  = var.deploy_bootstrap ? 1 : 0
  source = "../modules/bootstrap"

  root_parent_management_group_id        = local.root_parent_management_group_id
  architecture_name                      = local.architecture_name
  location                               = local.default_location
  default_prefix                         = var.default_prefix
  optional_postfix                       = var.optional_postfix
  enable_telemetry                       = var.enable_telemetry
  partner_id_uuid                        = local.partner_id_uuid
  landing_zone_management_group_children = var.landing_zone_management_group_children
  platform_management_group_children     = var.platform_management_group_children
  subscription_id_connectivity           = var.subscription_id_connectivity
  subscription_id_identity               = var.subscription_id_identity
  subscription_id_management             = var.subscription_id_management
  management_management_group_id         = local.management_management_group_id
  connectivity_management_group_id       = local.connectivity_management_group_id
  identity_management_group_id           = local.identity_management_group_id
  policy_default_values                  = local.slz_policy_default_values
  tenant_id                              = local.tenant_id
  top_level_management_group_name        = local.top_level_management_group_name
  default_policy_exemptions              = local.default_policy_exemptions
  log_analytics_workspace_resource_id    = var.log_analytics_workspace_resource_id
  default_security_groups                = var.default_security_groups
}

module "custom_exemption" {
  source = "../modules/policy_exemption"

  policy_exemptions = local.custom_policy_exemptions

  depends_on = [module.bootstrap]
}

module "dashboard" {
  count  = var.deploy_dashboard ? 1 : 0
  source = "../modules/dashboard"

  location                   = local.default_location
  default_prefix             = var.default_prefix
  optional_postfix           = var.optional_postfix
  enable_telemetry           = var.enable_telemetry
  customer                   = var.customer
  subscription_id_management = var.subscription_id_management
  dashboard_name             = local.dashboard_name
  tags                       = var.tags

  providers = {
    azurerm = azurerm.management
  }
}

module "platform" {
  count  = var.deploy_platform ? 1 : 0
  source = "../modules/platform"

  location                                  = local.default_location
  default_prefix                            = var.default_prefix
  optional_postfix                          = var.optional_postfix
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
  subscription_id_connectivity              = var.subscription_id_connectivity
  vpn_gateway_config                        = var.vpn_gateway_config
  bastion_outbound_ssh_rdp_ports            = var.bastion_outbound_ssh_rdp_ports

  providers = {
    azurerm.connectivity = azurerm.connectivity
    azurerm.management   = azurerm.management
  }
}
