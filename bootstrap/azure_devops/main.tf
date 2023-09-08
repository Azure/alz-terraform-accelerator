data "azurerm_client_config" "current" {}
data "azurerm_subscription" "current" {}

module "resource_names" {
  source = "./../modules/resource_names"
  azure_location = var.azure_location
  environment_name = var.environment_name
  service_name = var.service_name
  postfix_number = var.postfix_number
  resource_names = var.resource_names
}

module "azure" {
  source = "./../modules/azure"
  create_federated_credential = local.is_authentication_scheme_workload_identity_federation
  federated_credential_subject = module.azure_devops.subject
  federated_credential_issuer = module.azure_devops.issuer
  federated_credential_name = local.resource_names.user_assigned_managed_identity_federated_credentials
  create_agents_resource_group = local.is_authentication_scheme_managed_identity
  resource_group_identity_name = local.resource_names.user_assigned_managed_identity
  resource_group_agents_name = local.resource_names.resource_group_agents
  resource_group_state_name = local.resource_names.resource_group_state
  storage_account_name = local.resource_names.storage_account
  storage_container_name = local.resource_names.storage_container
  azure_location = var.azure_location
  user_assigned_managed_identity_name = local.resource_names.user_assigned_managed_identity
}

locals {
  starter_module_path = abspath("${path.module}/${var.template_folder_path}/${var.starter_module}")
  ci_cd_module_path = abspath("${path.module}/${var.template_folder_path}/${var.ci_cd_module}")
}

module "starter_module_files" {
  source = "./../modules/files"
  folder_path = local.starter_module_path
}

module "ci_cd_module_files" {
  source = "./../modules/files"
  folder_path = local.ci_cd_module_path
  exclusions = [ ".github" ]
}

output "files" {
  value = merge(module.starter_module_files.files, module.ci_cd_module_files.files)
}

module "azure_devops" {
  source = "./../modules/azure_devops"
  access_token = var.version_control_system_access_token
  organization_url = local.azure_devops_url
  organization_name = var.version_control_system_organization
  authentication_scheme = var.azure_devops_authentication_scheme
  create_project = var.azure_devops_create_project
  project_name = var.azure_devops_project_name
  environment_name = local.resource_names.version_control_system_environment
  repository_name = local.resource_names.version_control_system_repository
  repository_files = merge(module.starter_module_files.files, module.ci_cd_module_files.files)
  service_connection_name = local.resource_names.version_control_system_service_connection
  variable_group_name = local.resource_names.version_control_system_variable_group
  managed_identity_client_id = module.azure.user_assigned_managed_identity_client_id
  azure_tenant_id = data.azurerm_client_config.current.tenant_id
  azure_subscription_id = data.azurerm_client_config.current.subscription_id
  azure_subscription_name = data.azurerm_subscription.current.display_name
  pipeline_ci_file = ".azuredevops/ci.yaml"
  pipeline_cd_file = ".azuredevops/cd.yaml" 
}

