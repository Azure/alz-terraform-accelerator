locals {
  pipelines = {
    ci = {
      name = "Azure Landing Zone Continuous Integration"
      file = azuredevops_git_repository_file.alz[var.pipeline_ci_file].file
    }
    cd = {
      name = "Azure Landing Zone Continuous Delivery"
      file = azuredevops_git_repository_file.alz[var.pipeline_cd_file].file
    }
  }
}

resource "azuredevops_build_definition" "alz" {
  for_each   = local.pipelines
  project_id = local.project_id
  name       = each.value.name

  ci_trigger {
    use_yaml = true
  }

  repository {
    repo_type   = "TfsGit"
    repo_id     = azuredevops_git_repository.alz.id
    branch_name = azuredevops_git_repository.alz.default_branch
    yml_path    = each.value.file
  }
}

resource "azuredevops_pipeline_authorization" "alz_environment_plan" {
  for_each    = local.pipelines
  project_id  = local.project_id
  resource_id = azuredevops_environment.alz_plan.id
  type        = "environment"
  pipeline_id = azuredevops_build_definition.alz[each.key].id
}

resource "azuredevops_pipeline_authorization" "alz_environment_apply" {
  for_each    = local.pipelines
  project_id  = local.project_id
  resource_id = azuredevops_environment.alz_apply.id
  type        = "environment"
  pipeline_id = azuredevops_build_definition.alz[each.key].id
}

resource "azuredevops_pipeline_authorization" "alz_service_connection" {
  for_each    = local.pipelines
  project_id  = local.project_id
  resource_id = azuredevops_serviceendpoint_azurerm.alz.id
  type        = "endpoint"
  pipeline_id = azuredevops_build_definition.alz[each.key].id
}

resource "azuredevops_pipeline_authorization" "alz" {
  for_each    = local.pipelines
  project_id  = local.project_id
  resource_id = azuredevops_agent_queue.alz.id
  type        = "queue"
  pipeline_id = azuredevops_build_definition.alz[each.key].id
}