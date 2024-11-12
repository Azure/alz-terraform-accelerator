// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.
/*
SUMMARY : Local variables for the Management Groups and Subscriptions for the Landing Zone
AUTHOR/S: Cloud for Industry
*/
locals {
  subscription_id_management   = var.subscription_id_management != "" ? var.subscription_id_management : module.subscription_management_creation[0].subscription_id
  subscription_id_connectivity = var.subscription_id_connectivity != "" ? var.subscription_id_connectivity : module.subscription_connectivity_creation[0].subscription_id
  subscription_id_identity     = var.subscription_id_identity != "" ? var.subscription_id_identity : module.subscription_identity_creation[0].subscription_id

  # Management group timeouts
  management_group_timeouts = {
    role_definition = {
      create = "60m"
    }
  }

  # Management group retriable errors configuration
  management_group_retries = {
    role_definitions = {
      error_message_regex  = ["The specified role definition with ID '.+' does not exist."]
      interval_seconds     = 5
      max_interval_seconds = 30
    }
    subscription_placement = {
      error_message_regex  = ["'.+' not found", "Permission to write on resources of type 'Microsoft.Management/managementGroups' is required on the management group or its ancestors."]
      interval_seconds     = 5
      max_interval_seconds = 30
    }
  }

  landingzones_management_group_resource_id = "/providers/Microsoft.Management/managementGroups/${var.default_prefix}-landingzones${var.default_postfix}"

  management_management_group_id   = "${var.default_prefix}-platform-management${var.default_postfix}"
  connectivity_management_group_id = "${var.default_prefix}-platform-connectivity${var.default_postfix}"
  identity_management_group_id     = "${var.default_prefix}-platform-identity${var.default_postfix}"

  management_subscription_display_name   = "${var.default_prefix}-management${var.default_postfix}"
  connectivity_subscription_display_name = "${var.default_prefix}-connectivity${var.default_postfix}"
  identity_subscription_display_name     = "${var.default_prefix}-identity${var.default_postfix}"

  # Telemetry partner ID <PARTNER_ID_UUID>:<PARTNER_DATA_UUID>
  partner_id = format("%s:%s", var.partner_id_uuid, random_uuid.partner_data_uuid.result)

  # Management group information
  az_portal_link                                      = "https://portal.azure.com"
  url_encoded_top_level_management_group_display_name = replace(urlencode(var.management_group_top_level_display_name), "+", "%20")
  management_group_link                               = "${local.az_portal_link}/#view/Microsoft_Azure_Resources/ManagmentGroupDrilldownMenuBlade/~/overview/tenantId/${var.tenant_id}/mgId/${var.default_prefix}${var.default_postfix}/mgDisplayName/${local.url_encoded_top_level_management_group_display_name}/mgCanAddOrMoveSubscription~/true/mgParentAccessLevel/Owner/defaultMenuItemId/overview/drillDownMode~/true"
  management_group_info                               = "If you want to learn more about your management group, please click the following link.\n\n${local.management_group_link}\n\n"
}