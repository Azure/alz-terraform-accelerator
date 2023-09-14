data "azurerm_client_config" "current" {}

module "resource_names" {
  source           = "./../modules/resource_names"
  azure_location   = var.azure_location
  environment_name = var.environment_name
  service_name     = var.service_name
  postfix_number   = var.postfix_number
  resource_names   = var.resource_names
}

module "azure" {
  source                              = "./../modules/azure"
  federated_credential_subjects       = module.github.subjects
  federated_credential_issuer         = module.github.issuer
  federated_credential_name           = local.resource_names.user_assigned_managed_identity_federated_credentials
  resource_group_identity_name        = local.resource_names.resource_group_identity
  resource_group_state_name           = local.resource_names.resource_group_state
  storage_account_name                = local.resource_names.storage_account
  storage_container_name              = local.resource_names.storage_container
  azure_location                      = var.azure_location
  user_assigned_managed_identity_name = local.resource_names.user_assigned_managed_identity
  target_subscriptions                = var.target_subscriptions
  root_management_group_display_name  = var.root_management_group_display_name
}

locals {
  starter_module_path = abspath("${path.module}/${var.template_folder_path}/${var.starter_module}")
  ci_cd_module_path   = abspath("${path.module}/${var.template_folder_path}/${var.ci_cd_module}")
}

module "starter_module_files" {
  source      = "./../modules/files"
  folder_path = local.starter_module_path
  flag        = "module"
}

module "ci_cd_module_files" {
  source      = "./../modules/files"
  folder_path = local.ci_cd_module_path
  exclusions  = [".azuredevops"]
  flag        = "cicd"
}

module "github" {
  source                                       = "./../modules/github"
  access_token                                 = var.version_control_system_access_token
  organization_name                            = var.version_control_system_organization
  environment_name_plan                        = local.resource_names.version_control_system_environment_plan
  environment_name_apply                       = local.resource_names.version_control_system_environment_apply
  repository_name                              = local.resource_names.version_control_system_repository
  repository_visibility                        = var.repository_visibility
  repository_files                             = merge(module.starter_module_files.files, module.ci_cd_module_files.files)
  managed_identity_client_id                   = module.azure.user_assigned_managed_identity_client_id
  azure_tenant_id                              = data.azurerm_client_config.current.tenant_id
  azure_subscription_id                        = data.azurerm_client_config.current.subscription_id
  pipeline_ci_file                             = ".github/workflows/ci.yaml"
  pipeline_cd_file                             = ".github/workflows/cd.yaml"
  backend_azure_resource_group_name            = local.resource_names.resource_group_state
  backend_azure_storage_account_name           = local.resource_names.storage_account
  backend_azure_storage_account_container_name = local.resource_names.storage_container
  approvers                                    = var.apply_approvers
}

output "organization_users" {
  value = module.github.organization_users

}