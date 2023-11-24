resource "azuredevops_build_definition" "alz" {
  for_each   = local.pipelines
  project_id = local.project_id
  name       = each.value.pipeline_name

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

resource "azuredevops_pipeline_authorization" "alz_environment" {
  for_each    = local.pipeline_environments_map
  project_id  = local.project_id
  resource_id = each.value.environment_id
  type        = "environment"
  pipeline_id = each.value.pipeline_id
}

resource "azuredevops_pipeline_authorization" "alz_service_connection" {
  for_each    = local.pipeline_service_connections_map
  project_id  = local.project_id
  resource_id = each.value.service_connection_id
  type        = "endpoint"
  pipeline_id = each.value.pipeline_id
}

resource "azuredevops_pipeline_authorization" "alz_agent_pool" {
  for_each    = local.pipeline_agent_pools_map
  project_id  = local.project_id
  resource_id = each.value.agent_pool_id
  type        = "queue"
  pipeline_id = each.value.pipeline_id
}
