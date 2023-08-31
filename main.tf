data "azurerm_client_config" "current" {}

module "azure_devops" {
  source = "modules/azure_devops"
  count = var.version_control_system == "azure_devops" ? 1 : 0
}

module "github" {
  source = "modules/github"
  count = var.version_control_system == "github" ? 1 : 0
}