resource "random_pet" "example" {

}

resource "github_repository" "example" {
  name        = "${var.prefix}-${random_pet.example.id}"
  description = "Example repository ${random_pet.example.id}"
  auto_init   = false

  template {
    owner      = var.github_organisation_template
    repository = var.github_repository_template
  }
}

resource "github_repository_environment" "example" {
  for_each    = { for env in var.environments : env => env }
  environment = each.value
  repository  = github_repository.example.name
}

resource "github_actions_environment_secret" "azure_client_id" {
  for_each        = { for env in var.environments : env => env }
  repository      = github_repository.example.name
  environment     = github_repository_environment.example[each.value].environment
  secret_name     = "AZURE_CLIENT_ID"
  plaintext_value = var.use_managed_identity ? azurerm_user_assigned_identity.example[each.value].client_id : azuread_application.github_oidc[each.value].application_id
}

resource "github_actions_environment_secret" "azure_subscription_id" {
  for_each        = { for env in var.environments : env => env }
  repository      = github_repository.example.name
  environment     = github_repository_environment.example[each.value].environment
  secret_name     = "AZURE_SUBSCRIPTION_ID"
  plaintext_value = data.azurerm_client_config.current.subscription_id
}

resource "github_actions_environment_secret" "azure_tenant_id" {
  for_each        = { for env in var.environments : env => env }
  repository      = github_repository.example.name
  environment     = github_repository_environment.example[each.value].environment
  secret_name     = "AZURE_TENANT_ID"
  plaintext_value = data.azurerm_client_config.current.tenant_id
}

resource "github_actions_environment_secret" "azure_resource_group_name" {
  for_each        = { for env in var.environments : env => env }
  repository      = github_repository.example.name
  environment     = github_repository_environment.example[each.value].environment
  secret_name     = "AZURE_RESOURCE_GROUP_NAME"
  plaintext_value = azurerm_resource_group.example[each.value].name
}

resource "github_actions_environment_secret" "backend_azure_resource_group_name" {
  for_each        = { for env in var.environments : env => env }
  repository      = github_repository.example.name
  environment     = github_repository_environment.example[each.value].environment
  secret_name     = "BACKEND_AZURE_RESOURCE_GROUP_NAME"
  plaintext_value = azurerm_resource_group.state.name
}

resource "github_actions_environment_secret" "backend_azure_storage_account_name" {
  for_each        = { for env in var.environments : env => env }
  repository      = github_repository.example.name
  environment     = github_repository_environment.example[each.value].environment
  secret_name     = "BACKEND_AZURE_STORAGE_ACCOUNT_NAME"
  plaintext_value = azurerm_storage_account.example.name
}

resource "github_actions_environment_secret" "backend_azure_storage_account_container_name" {
  for_each        = { for env in var.environments : env => env }
  repository      = github_repository.example.name
  environment     = github_repository_environment.example[each.value].environment
  secret_name     = "BACKEND_AZURE_STORAGE_ACCOUNT_CONTAINER_NAME"
  plaintext_value = azurerm_storage_container.example[each.value].name
}
