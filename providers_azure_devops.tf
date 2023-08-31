provider "azuredevops" {
  org_service_url       = "${var.azure_devops_organisation_prefix}/${var.azure_devops_organisation_target}"
  personal_access_token = var.azure_devops_token
}