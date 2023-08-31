locals {
  is_oidc           = local.security_option.oidc_with_user_assigned_managed_identity || local.security_option.oidc_with_app_registration
  is_mi             = local.security_option.self_hosted_agents_with_managed_identity
  oidc_environments = local.is_oidc ? { for env in var.environments : env => env } : {}
  mi_environments   = local.is_mi ? { for env in var.environments : env => env } : {}
}

resource "random_pet" "example" {

}

data "azuredevops_project" "example" {
  name = var.azure_devops_project_target
}

resource "azuredevops_environment" "example" {
  for_each   = { for env in var.environments : env => env }
  name       = each.value
  project_id = data.azuredevops_project.example.id
}

resource "azuredevops_git_repository" "example" {
  depends_on = [azuredevops_environment.example]
  project_id = data.azuredevops_project.example.id
  name       = "${var.prefix}-${random_pet.example.id}"
  initialization {
    init_type   = "Import"
    source_type = "Git"
    source_url  = "https://github.com/${var.github_organisation_template}/${var.github_repository_template}.git"
  }
}

resource "azuredevops_build_definition" "oidc" {
  count      = local.is_oidc ? 1 : 0
  project_id = data.azuredevops_project.example.id
  name       = "Run Terraform with OpenID Connect"

  ci_trigger {
    use_yaml = true
  }

  repository {
    repo_type   = "TfsGit"
    repo_id     = azuredevops_git_repository.example.id
    branch_name = azuredevops_git_repository.example.default_branch
    yml_path    = "pipelines/oidc.yml"
  }
}

resource "azuredevops_build_definition" "mi" {
  count      = local.is_mi ? 1 : 0
  project_id = data.azuredevops_project.example.id
  name       = "Run Terraform with Managed Identity"

  ci_trigger {
    use_yaml = true
  }

  repository {
    repo_type   = "TfsGit"
    repo_id     = azuredevops_git_repository.example.id
    branch_name = azuredevops_git_repository.example.default_branch
    yml_path    = "pipelines/mi.yml"
  }
}

resource "azuredevops_pipeline_authorization" "oidc" {
  for_each    = local.oidc_environments
  project_id  = data.azuredevops_project.example.id
  resource_id = azuredevops_environment.example[each.value].id
  type        = "environment"
  pipeline_id = azuredevops_build_definition.oidc[0].id
}

resource "azuredevops_pipeline_authorization" "mi" {
  for_each    = local.mi_environments
  project_id  = data.azuredevops_project.example.id
  resource_id = azuredevops_environment.example[each.value].id
  type        = "environment"
  pipeline_id = azuredevops_build_definition.mi[0].id
}

resource "azuredevops_branch_policy_build_validation" "oidc" {
  count      = local.is_oidc ? 1 : 0
  project_id = data.azuredevops_project.example.id

  enabled  = true
  blocking = true

  settings {
    display_name        = "Terraform validation policy with OpenID Connect"
    build_definition_id = azuredevops_build_definition.oidc[0].id
    valid_duration      = 720

    scope {
      repository_id  = azuredevops_git_repository.example.id
      repository_ref = azuredevops_git_repository.example.default_branch
      match_type     = "Exact"
    }

    scope {
      match_type = "DefaultBranch"
    }
  }
}

resource "azuredevops_branch_policy_build_validation" "mi" {
  count      = local.is_mi ? 1 : 0
  project_id = data.azuredevops_project.example.id

  enabled  = true
  blocking = true

  settings {
    display_name        = "Terraform validation policy with Managed Identity"
    build_definition_id = azuredevops_build_definition.mi[0].id
    valid_duration      = 720

    scope {
      repository_id  = azuredevops_git_repository.example.id
      repository_ref = azuredevops_git_repository.example.default_branch
      match_type     = "Exact"
    }

    scope {
      match_type = "DefaultBranch"
    }
  }
}

resource "azuredevops_variable_group" "example" {
  for_each     = { for env in var.environments : env => env }
  project_id   = data.azuredevops_project.example.id
  name         = each.value
  description  = "Example Variable Group for ${each.value}"
  allow_access = true

  variable {
    name  = "AZURE_RESOURCE_GROUP_NAME"
    value = azurerm_resource_group.example[each.value].name
  }

  variable {
    name  = "BACKEND_AZURE_RESOURCE_GROUP_NAME"
    value = azurerm_resource_group.state.name
  }

  variable {
    name  = "BACKEND_AZURE_STORAGE_ACCOUNT_NAME"
    value = azurerm_storage_account.example.name
  }

  variable {
    name  = "BACKEND_AZURE_STORAGE_ACCOUNT_CONTAINER_NAME"
    value = azurerm_storage_container.example[each.value].name
  }
}