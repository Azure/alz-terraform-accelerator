// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.
/*
SUMMARY : Local variables for the dashboard
AUTHOR/S: Cloud for Industry
*/
locals {
  az_portal_link                  = "https://portal.azure.com"
  dashboard_resource_group_name   = "${var.default_prefix}-rg-dashboards-${var.location}${var.default_postfix}"
  dashboard_name                  = "${var.default_prefix}-${var.dashboard_name}-${var.location}${var.default_postfix}"
  dashboard_template_file_path    = "${path.root}/templates/default_dashboard.tpl"
  template_file_variables         = { root_prefix = var.default_prefix, root_postfix = var.default_postfix, customer = var.customer }
  default_template_file_variables = { name = local.dashboard_name }
  all_template_file_variables     = merge(local.default_template_file_variables, local.template_file_variables)
  domain_name                     = data.azuread_domains.default.domains[0].domain_name
  dashboard_link                  = "${local.az_portal_link}/#@${local.domain_name}/dashboard/arm/subscriptions/${var.subscription_id_management}/resourceGroups/${local.dashboard_resource_group_name}/providers/Microsoft.Portal/dashboards/${local.dashboard_name}"
  dashboard_info                  = "Now your compliance dashboard is ready for you to get insights. If you want to learn more, please click the following link.\n\n${local.dashboard_link}\n\n"
}
