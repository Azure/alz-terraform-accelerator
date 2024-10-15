// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.
/*
SUMMARY : Deploys the Management Groups and Subscriptions for the Sovereign Landing Zone
AUTHOR/S: Cloud for Sovereignty
*/
resource "random_uuid" "partner_data_uuid" {
}

module "slz_management_groups" {
  source                = "Azure/avm-ptn-alz/azurerm"
  version               = "0.9.0-beta2"
  parent_resource_id    = local.root_parent_management_group_id
  architecture_name     = local.architecture_name
  location              = var.default_location
  enable_telemetry      = var.enable_telemetry
  policy_default_values = local.slz_default_policy_values
  partner_id            = local.partner_id
  timeouts              = local.slz_management_group_timeouts
  retries               = local.slz_management_group_retries
}

resource "azurerm_management_group" "child" {
  for_each                   = var.landing_zone_management_group_children
  display_name               = each.value.displayName
  name                       = each.value.id
  parent_management_group_id = local.landingzones_management_group_id

  depends_on = [module.slz_management_groups]
}

module "subscription_management_creation" {
  count   = var.subscription_id_management == "" ? 1 : 0
  source  = "Azure/lz-vending/azurerm//modules/subscription"
  version = "~> 4.1.2"

  subscription_alias_enabled                        = true
  subscription_billing_scope                        = var.subscription_billing_scope
  subscription_display_name                         = local.management_subscription_display_name
  subscription_alias_name                           = local.management_subscription_display_name
  subscription_workload                             = "Production"
  subscription_management_group_association_enabled = true
  subscription_management_group_id                  = local.management_management_group_id
  depends_on                                        = [module.slz_management_groups]
}

module "subscription_management_move" {
  count                                             = var.subscription_id_management == "" ? 0 : 1
  source                                            = "Azure/lz-vending/azurerm//modules/subscription"
  version                                           = "~> 4.1.2"
  subscription_display_name                         = local.management_subscription_display_name
  subscription_alias_name                           = local.management_subscription_display_name
  subscription_workload                             = "Production"
  subscription_id                                   = var.subscription_id_management
  subscription_management_group_association_enabled = true
  subscription_management_group_id                  = local.management_management_group_id
  depends_on                                        = [module.subscription_management_creation]
}

module "subscription_identity_creation" {
  count                                             = var.subscription_id_identity == "" ? 1 : 0
  source                                            = "Azure/lz-vending/azurerm//modules/subscription"
  version                                           = "~> 4.1.2"
  subscription_alias_enabled                        = true
  subscription_billing_scope                        = var.subscription_billing_scope
  subscription_display_name                         = local.identity_subscription_display_name
  subscription_alias_name                           = local.identity_subscription_display_name
  subscription_workload                             = "Production"
  subscription_management_group_association_enabled = true
  subscription_management_group_id                  = local.identity_management_group_id
  depends_on                                        = [module.slz_management_groups]
}

module "subscription_identity_move" {
  count                                             = var.subscription_id_identity == "" ? 0 : 1
  source                                            = "Azure/lz-vending/azurerm//modules/subscription"
  version                                           = "~> 4.1.2"
  subscription_workload                             = "Production"
  subscription_id                                   = var.subscription_id_identity
  subscription_display_name                         = local.identity_subscription_display_name
  subscription_alias_name                           = local.identity_subscription_display_name
  subscription_management_group_association_enabled = true
  subscription_management_group_id                  = local.identity_management_group_id
  depends_on                                        = [module.subscription_identity_creation]
}

module "subscription_connectivity_creation" {
  count                                             = var.subscription_id_connectivity == "" ? 1 : 0
  source                                            = "Azure/lz-vending/azurerm//modules/subscription"
  version                                           = "~> 4.1.2"
  subscription_alias_enabled                        = true
  subscription_billing_scope                        = var.subscription_billing_scope
  subscription_display_name                         = local.connectivity_subscription_display_name
  subscription_alias_name                           = local.connectivity_subscription_display_name
  subscription_workload                             = "Production"
  subscription_management_group_association_enabled = true
  subscription_management_group_id                  = local.connectivity_management_group_id
  depends_on                                        = [module.slz_management_groups]
}

module "subscription_connectivity_move" {
  count                                             = var.subscription_id_connectivity == "" ? 0 : 1
  source                                            = "Azure/lz-vending/azurerm//modules/subscription"
  version                                           = "~> 4.1.2"
  subscription_workload                             = "Production"
  subscription_id                                   = var.subscription_id_connectivity
  subscription_display_name                         = local.connectivity_subscription_display_name
  subscription_alias_name                           = local.connectivity_subscription_display_name
  subscription_management_group_association_enabled = true
  subscription_management_group_id                  = local.connectivity_management_group_id
  depends_on                                        = [module.subscription_connectivity_creation]
}