// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.
/*
SUMMARY : Deploys the dashboard for the Sovereign Landing Zone
AUTHOR/S: Cloud for Sovereignty
*/
module "dashboard_rg" {
  source           = "Azure/avm-res-resources-resourcegroup/azurerm"
  version          = "0.1.0"
  location         = local.default_location
  name             = local.dashboard_resource_group_name
  enable_telemetry = var.enable_telemetry
  providers = {
    azurerm = azurerm.management
  }
}

module "avm_res_portal_dashboard" {
  source                  = "Azure/avm-res-portal-dashboard/azurerm"
  version                 = "0.1.0"
  location                = local.default_location
  name                    = local.dashboard_name
  resource_group_name     = module.dashboard_rg.name
  template_file_path      = local.dashboard_template_file_path
  template_file_variables = local.all_template_file_variables
  enable_telemetry        = var.enable_telemetry

  depends_on = [module.subscription_management_creation, module.dashboard_rg]

  providers = {
    azurerm = azurerm.management
  }
}
