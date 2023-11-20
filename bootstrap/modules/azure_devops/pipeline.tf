locals {
  pipelines = { for key, value in var.pipelines : key => {
    pipeline_name = value.pipeline_name
    file          = azuredevops_git_repository_file.alz[value.file_path].file
    environments = [for environment_key in value.environment_keys : {
      environment_key = environment_key
      environment_id  = azuredevops_environment.alz[environment_key].id
    }]
    service_connections = [for service_connection_key in value.service_connection_keys :
      {
        service_connection_key = service_connection_key
        service_connection_id  = azuredevops_serviceendpoint_azurerm.alz[service_connection_key].id
    }]
    agent_pools = local.is_authentication_scheme_managed_identity ? [for agent_pool_key in value.agent_pool_keys :
      {
        agent_pool_key = agent_pool_key
        agent_pool_id  = azuredevops_agent_queue.alz[agent_pool_key].id
    }] : []
    }
  }

  pipeline_environments = flatten([for pipeline_key, pipeline in local.pipelines :
    [for environment in pipeline.environments : {
      pipeline_key    = pipeline_key
      environment_key = environment.environment_key
      pipeline_id     = azuredevops_build_definition.alz[pipeline_key].id
      environment_id  = environment.environment_id
      }
    ]
  ])

  pipeline_service_connections = flatten([for pipeline_key, pipeline in local.pipelines :
    [for service_connection in pipeline.service_connections : {
      pipeline_key           = pipeline_key
      service_connection_key = service_connection.service_connection_key
      pipeline_id            = azuredevops_build_definition.alz[pipeline_key].id
      service_connection_id  = service_connection.service_connection_id
      }
    ]
  ])

  pipeline_agent_pools = local.is_authentication_scheme_managed_identity ? flatten([for pipeline_key, pipeline in local.pipelines :
    [for agent_pool in pipeline.agent_pools : {
      pipeline_key   = pipeline_key
      agent_pool_key = agent_pool.agent_pool_key
      pipeline_id    = azuredevops_build_definition.alz[pipeline_key].id
      agent_pool_id  = agent_pool.agent_pool_id
      }
    ]
  ]) : []

  pipeline_environments_map = { for pipeline_environment in local.pipeline_environments : "${pipeline_environment.pipeline_key}-${pipeline_environment.environment_key}" => {
    pipeline_id    = pipeline_environment.pipeline_id
    environment_id = pipeline_environment.environment_id
    }
  }

  pipeline_service_connections_map = { for pipeline_service_connection in local.pipeline_service_connections : "${pipeline_service_connection.pipeline_key}-${pipeline_service_connection.service_connection_key}" => {
    pipeline_id           = pipeline_service_connection.pipeline_id
    service_connection_id = pipeline_service_connection.service_connection_id
    }
  }

  pipeline_agent_pools_map = { for pipeline_agent_pool in local.pipeline_agent_pools : "${pipeline_agent_pool.pipeline_key}-${pipeline_agent_pool.agent_pool_key}" => {
    pipeline_id   = pipeline_agent_pool.pipeline_id
    agent_pool_id = pipeline_agent_pool.agent_pool_id
    }
  }
}

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
