locals {
  default_branch = "refs/heads/main"
}

resource "azuredevops_git_repository" "alz" {
  depends_on     = [azuredevops_environment.alz_plan, azuredevops_environment.alz_apply]
  project_id     = local.project_id
  name           = var.repository_name
  default_branch = local.default_branch
  initialization {
    init_type = "Clean"
  }
}

locals {
  agent_pool_configuration = local.is_authentication_scheme_managed_identity ? "name: ${var.agent_pool_name}" : "vmImage: ubuntu-latest"
  repository_files = { for key, value in var.repository_files : key =>
    {
      path = value
      content = templatefile(value, {
        agent_pool_configuration = local.agent_pool_configuration
        service_connection_name  = var.service_connection_name
        environment_name_plan    = var.environment_name_plan
        environment_name_apply   = var.environment_name_apply
        variable_group_name      = var.variable_group_name
      })
    }
  }
}

resource "azuredevops_git_repository_file" "alz" {
  for_each      = local.repository_files
  repository_id = azuredevops_git_repository.alz.id
  file          = each.key
  content       = each.value.content
  branch        = local.default_branch
}