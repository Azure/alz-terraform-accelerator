data "azurerm_client_config" "current" {}
/* 
module "azure_devops" {
  source = "modules/azure_devops"
  count = local.is_azure_devops ? 1 : 0
}

module "github" {
  source = "modules/github"
  count = local.is_github ? 1 : 0
} */