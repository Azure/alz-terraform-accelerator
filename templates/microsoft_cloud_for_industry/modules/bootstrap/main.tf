// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.
/*
SUMMARY : Deploys the Management Groups and Subscriptions for the Landing Zone
AUTHOR/S: Cloud for Industry
*/
resource "random_uuid" "partner_data_uuid" {
}

module "management_groups" {
  source  = "Azure/avm-ptn-alz/azurerm"
  version = "0.9.0-beta2"

  parent_resource_id    = var.root_parent_management_group_id
  architecture_name     = var.architecture_name
  location              = var.location
  enable_telemetry      = var.enable_telemetry
  policy_default_values = var.policy_default_values
  partner_id            = local.partner_id
  timeouts              = local.management_group_timeouts
  retries               = local.management_group_retries

  subscription_placement = {
    management = {
      subscription_id       = local.subscription_id_management
      management_group_name = local.management_management_group_id
    }
    identity = {
      subscription_id       = local.subscription_id_identity
      management_group_name = local.identity_management_group_id
    }
    connectivity = {
      subscription_id       = local.subscription_id_connectivity
      management_group_name = local.connectivity_management_group_id
    }
  }
}

resource "azurerm_management_group" "child" {
  for_each                   = var.landing_zone_management_group_children
  display_name               = each.value.displayName
  name                       = each.value.id
  parent_management_group_id = local.landingzones_management_group_resource_id

  depends_on = [module.management_groups]
}

module "subscription_management_creation" {
  count   = var.subscription_id_management == "" ? 1 : 0
  source  = "Azure/lz-vending/azurerm//modules/subscription"
  version = "~> 4.1.2"

  subscription_alias_enabled = true
  subscription_billing_scope = var.subscription_billing_scope
  subscription_display_name  = local.management_subscription_display_name
  subscription_alias_name    = local.management_subscription_display_name
  subscription_workload      = "Production"
}

module "subscription_identity_creation" {
  count   = var.subscription_id_identity == "" ? 1 : 0
  source  = "Azure/lz-vending/azurerm//modules/subscription"
  version = "~> 4.1.2"

  subscription_alias_enabled = true
  subscription_billing_scope = var.subscription_billing_scope
  subscription_display_name  = local.identity_subscription_display_name
  subscription_alias_name    = local.identity_subscription_display_name
  subscription_workload      = "Production"
}

module "subscription_connectivity_creation" {
  count   = var.subscription_id_connectivity == "" ? 1 : 0
  source  = "Azure/lz-vending/azurerm//modules/subscription"
  version = "~> 4.1.2"

  subscription_alias_enabled = true
  subscription_billing_scope = var.subscription_billing_scope
  subscription_display_name  = local.connectivity_subscription_display_name
  subscription_alias_name    = local.connectivity_subscription_display_name
  subscription_workload      = "Production"
}