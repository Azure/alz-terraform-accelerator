data "azurerm_client_config" "current" {}

module "azure_devops" {
  source = "./modules/azure_devops"
  count = local.is_azure_devops ? 1 : 0
  access_token = var.version_control_system_access_token
  organization_url = local.azure_devops_url
  authentication_scheme = var.azure_devops_authentication_scheme
}

module "github" {
  source = "./modules/github"
  count = local.is_github ? 1 : 0
}