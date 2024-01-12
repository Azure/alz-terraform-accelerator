module "resource_names" {
  source           = "./../modules/resource_names"
  azure_location   = var.bootstrap_location
  environment_name = var.environment_name
  service_name     = var.service_name
  postfix_number   = var.postfix_number
  resource_names   = var.resource_names
}

module "files" {
  source                     = "./../modules/files"
  starter_module_folder_path = local.starter_module_folder_path
  additional_files           = var.additional_files
}

module "azure" {
  source                                    = "./../modules/azure"
  count                                     = var.create_bootstrap_resources_in_azure ? 1 : 0
  user_assigned_managed_identities          = local.managed_identities
  federated_credentials                     = local.federated_credentials
  resource_group_identity_name              = local.resource_names.resource_group_identity
  resource_group_state_name                 = local.resource_names.resource_group_state
  storage_account_name                      = local.resource_names.storage_account
  storage_container_name                    = local.resource_names.storage_container
  azure_location                            = var.bootstrap_location
  target_subscriptions                      = var.target_subscriptions
  root_parent_management_group_display_name = var.root_parent_management_group_display_name
}

resource "local_file" "alz" {
  for_each = local.module_files
  content  = each.value.content
  filename = "${local.target_directory}/${each.key}"
}
