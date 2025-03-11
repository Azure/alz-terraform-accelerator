// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.
/*
SUMMARY : Deploys the dashboard for the Landing Zone
AUTHOR/S: Cloud for Industry
*/
module "dashboard_rg" {
  source  = "Azure/avm-res-resources-resourcegroup/azurerm"
  version = "0.1.0"

  location         = var.location
  name             = local.dashboard_resource_group_name
  enable_telemetry = var.enable_telemetry
  tags             = var.tags
}

module "avm_res_portal_dashboard" {
  source  = "Azure/avm-res-portal-dashboard/azurerm"
  version = "0.1.0"

  location                = var.location
  name                    = local.dashboard_name
  resource_group_name     = local.dashboard_resource_group_name
  template_file_path      = local.dashboard_template_file_path
  template_file_variables = local.all_template_file_variables
  enable_telemetry        = var.enable_telemetry
  tags                    = var.tags
  depends_on              = [module.dashboard_rg]
}
