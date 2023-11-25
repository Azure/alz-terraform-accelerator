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
  create_agents_resource_group       = module.azure_devops.is_authentication_scheme_managed_identity
  resource_group_identity_name       = local.resource_names.resource_group_identity
  resource_group_agents_name         = local.resource_names.resource_group_agents
  resource_group_state_name          = local.resource_names.resource_group_state
  storage_account_name               = local.resource_names.storage_account
  storage_container_name             = local.resource_names.storage_container
  azure_location                     = var.azure_location
  user_assigned_managed_identities   = local.managed_identities
  create_federated_credential        = module.azure_devops.is_authentication_scheme_workload_identity_federation
  federated_credentials              = local.federated_credentials
  create_agents                      = module.azure_devops.is_authentication_scheme_managed_identity
  agent_container_instances          = local.agent_container_instances
  agent_container_instance_image     = var.agent_container_image
  agent_organization_url             = module.azure_devops.organization_url
  agent_token                        = var.version_control_system_access_token
  target_subscriptions               = var.target_subscriptions
  root_management_group_display_name = var.root_management_group_display_name
}

module "azure_devops" {
  source                                       = "./../modules/azure_devops"
  use_legacy_organization_url                  = var.azure_devops_use_organisation_legacy_url
  organization_name                            = var.version_control_system_organization
  authentication_scheme                        = var.azure_devops_authentication_scheme
  create_project                               = var.azure_devops_create_project
  project_name                                 = var.azure_devops_project_name
  environments                                 = local.environments
  managed_identity_client_ids                  = module.azure.user_assigned_managed_identity_client_ids
  repository_name                              = local.resource_names.version_control_system_repository
  repository_files                             = module.files.files
  use_template_repository                      = var.version_control_system_use_separate_repository_for_templates
  repository_name_templates                    = local.resource_names.version_control_system_repository_templates
  variable_group_name                          = local.resource_names.version_control_system_variable_group
  azure_tenant_id                              = data.azurerm_client_config.current.tenant_id
  azure_subscription_id                        = data.azurerm_client_config.current.subscription_id
  azure_subscription_name                      = data.azurerm_subscription.current.display_name
  pipelines                                    = var.pipeline_files
  pipeline_templates                           = var.pipeline_template_files
  backend_azure_resource_group_name            = local.resource_names.resource_group_state
  backend_azure_storage_account_name           = local.resource_names.storage_account
  backend_azure_storage_account_container_name = local.resource_names.storage_container
  approvers                                    = var.apply_approvers
  group_name                                   = local.resource_names.version_control_system_group
}
