data "azurerm_client_config" "current" {}
data "azurerm_subscription" "current" {}

module "resource_names" {
  source           = "./../modules/resource_names"
  azure_location   = var.azure_location
  environment_name = var.environment_name
  service_name     = var.service_name
  postfix_number   = var.postfix_number
  resource_names   = var.resource_names
}

locals {
  managed_identities = {
    "${local.plan_key}"  = local.resource_names.user_assigned_managed_identity_plan
    "${local.apply_key}" = local.resource_names.user_assigned_managed_identity_apply
  }

  federated_credentials = {
    "${local.plan_key}" = {
      federated_credential_subject = module.azure_devops.subjects[local.plan_key]
      federated_credential_issuer  = module.azure_devops.issuers[local.plan_key]
      federated_credential_name    = local.resource_names.user_assigned_managed_identity_federated_credentials_plan
    }
    "${local.apply_key}" = {
      federated_credential_subject = module.azure_devops.subjects[local.apply_key]
      federated_credential_issuer  = module.azure_devops.issuers[local.apply_key]
      federated_credential_name    = local.resource_names.user_assigned_managed_identity_federated_credentials_apply
    }
  }

  agent_container_instances = module.azure_devops.is_authentication_scheme_managed_identity ? {
    agent_01 = {
      container_instance_name = local.resource_names.container_instance_01
      agent_name              = local.resource_names.agent_01
      managed_identity_key    = local.plan_key
      agent_pool_name         = module.azure_devops.is_authentication_scheme_managed_identity ? module.azure_devops.agent_pool_names[local.plan_key] : ""
    }
    agent_02 = {
      container_instance_name = local.resource_names.container_instance_02
      agent_name              = local.resource_names.agent_02
      managed_identity_key    = local.plan_key
      agent_pool_name         = module.azure_devops.is_authentication_scheme_managed_identity ? module.azure_devops.agent_pool_names[local.plan_key] : ""
    }
    agent_03 = {
      container_instance_name = local.resource_names.container_instance_03
      agent_name              = local.resource_names.agent_03
      managed_identity_key    = local.apply_key
      agent_pool_name         = module.azure_devops.is_authentication_scheme_managed_identity ? module.azure_devops.agent_pool_names[local.apply_key] : ""
    }
    agent_04 = {
      container_instance_name = local.resource_names.container_instance_04
      agent_name              = local.resource_names.agent_04
      managed_identity_key    = local.apply_key
      agent_pool_name         = module.azure_devops.is_authentication_scheme_managed_identity ? module.azure_devops.agent_pool_names[local.apply_key] : ""
    }
  } : {}
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
  exclusions  = [".github"]
  flag        = "cicd"
}

locals {
  starter_module_repo_files = merge(module.starter_module_files.files, module.ci_cd_module_files.files)
  additional_repo_files = { for file in var.additional_files : basename(file) => {
    path = file
    flag = "additional"
    }
  }
  all_repo_files = merge(local.starter_module_repo_files, local.additional_repo_files)
}

locals {
  environments = {
    "${local.plan_key}" = {
      environment_name        = local.resource_names.version_control_system_environment_plan
      service_connection_name = local.resource_names.version_control_system_service_connection_plan
      agent_pool_name         = local.resource_names.version_control_system_agent_pool_plan
    }
    "${local.apply_key}" = {
      environment_name        = local.resource_names.version_control_system_environment_apply
      service_connection_name = local.resource_names.version_control_system_service_connection_apply
      agent_pool_name         = local.resource_names.version_control_system_agent_pool_apply
    }
  }
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
  repository_files                             = local.all_repo_files
  variable_group_name                          = local.resource_names.version_control_system_variable_group
  azure_tenant_id                              = data.azurerm_client_config.current.tenant_id
  azure_subscription_id                        = data.azurerm_client_config.current.subscription_id
  azure_subscription_name                      = data.azurerm_subscription.current.display_name
  pipeline_ci_file                             = ".azuredevops/ci.yaml"
  pipeline_cd_file                             = ".azuredevops/cd.yaml"
  backend_azure_resource_group_name            = local.resource_names.resource_group_state
  backend_azure_storage_account_name           = local.resource_names.storage_account
  backend_azure_storage_account_container_name = local.resource_names.storage_container
  approvers                                    = var.apply_approvers
  group_name                                   = local.resource_names.version_control_system_group
}
