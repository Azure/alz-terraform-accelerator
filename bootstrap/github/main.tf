module "resource_names" {
  source           = "./../modules/resource_names"
  azure_location   = var.azure_location
  environment_name = var.environment_name
  service_name     = var.service_name
  postfix_number   = var.postfix_number
  resource_names   = var.resource_names
}

module "files" {
  source      = "./../modules/files"
  module_folder_path_relative = var.module_folder_path_relative
  module_folder_path = var.module_folder_path
  starter_module = var.starter_module
  pipeline_folder_path_relative = var.pipeline_folder_path_relative
  pipeline_folder_path = var.pipeline_folder_path
  pipeline_files = var.pipeline_files
  pipeline_template_files = var.pipeline_template_files
  additional_files = var.additional_files
}

module "azure" {
  source                             = "./../modules/azure"
  user_assigned_managed_identities   = local.managed_identities
  federated_credentials              = local.federated_credentials
  resource_group_identity_name       = local.resource_names.resource_group_identity
  resource_group_state_name          = local.resource_names.resource_group_state
  storage_account_name               = local.resource_names.storage_account
  storage_container_name             = local.resource_names.storage_container
  azure_location                     = var.azure_location
  target_subscriptions               = var.target_subscriptions
  root_management_group_display_name = var.root_management_group_display_name
}

module "github" {
  source                                       = "./../modules/github"
  organization_name                            = var.version_control_system_organization
  environments                                 = local.environments
  repository_name                              = local.resource_names.version_control_system_repository
  use_template_repository                      = var.version_control_system_use_separate_repository_for_templates
  repository_name_templates                    = local.resource_names.version_control_system_repository_templates
  repository_visibility                        = var.repository_visibility
  repository_files                             = module.files.files
  pipeline_templates                           = var.pipeline_template_files
  managed_identity_client_ids                  = module.azure.user_assigned_managed_identity_client_ids
  azure_tenant_id                              = data.azurerm_client_config.current.tenant_id
  azure_subscription_id                        = data.azurerm_client_config.current.subscription_id
  backend_azure_resource_group_name            = local.resource_names.resource_group_state
  backend_azure_storage_account_name           = local.resource_names.storage_account
  backend_azure_storage_account_container_name = local.resource_names.storage_container
  approvers                                    = var.apply_approvers
  team_name                                    = local.resource_names.version_control_system_team
}
