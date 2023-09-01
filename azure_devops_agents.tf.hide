locals {
  agent_pools = local.security_option.self_hosted_agents_with_managed_identity ? {
    dev  = "agent-pool-dev"
    test = "agent-pool-test"
    prod = "agent-pool-prod"
  } : {}
  agents = local.security_option.self_hosted_agents_with_managed_identity ? {
    dev01 = {
      name        = "aciado-${lower(var.prefix)}-dev-001"
      environment = "dev"
      identity    = azurerm_user_assigned_identity.example["dev"].id
      pool        = azuredevops_agent_pool.this["dev"].name
    }
    dev02 = {
      name        = "aciado-${lower(var.prefix)}-dev-002"
      environment = "dev"
      identity    = azurerm_user_assigned_identity.example["dev"].id
      pool        = azuredevops_agent_pool.this["dev"].name
    }
    test01 = {
      name        = "aciado-${lower(var.prefix)}-test-001"
      environment = "test"
      identity    = azurerm_user_assigned_identity.example["test"].id
      pool        = azuredevops_agent_pool.this["test"].name
    }
    test02 = {
      name        = "aciado-${lower(var.prefix)}-test-002"
      environment = "test"
      identity    = azurerm_user_assigned_identity.example["test"].id
      pool        = azuredevops_agent_pool.this["test"].name
    }
    prod01 = {
      name        = "aciado-${lower(var.prefix)}-prod-001"
      environment = "prod"
      identity    = azurerm_user_assigned_identity.example["prod"].id
      pool        = azuredevops_agent_pool.this["prod"].name
    }
    prod02 = {
      name        = "aciado-${lower(var.prefix)}-prod-002"
      environment = "prod"
      identity    = azurerm_user_assigned_identity.example["prod"].id
      pool        = azuredevops_agent_pool.this["prod"].name
    }
  } : {}
}

resource "azuredevops_agent_pool" "this" {
  for_each       = local.agent_pools
  name           = each.value
  auto_provision = false
  auto_update    = true
}

resource "azuredevops_agent_queue" "this" {
  for_each      = local.agent_pools
  project_id    = data.azuredevops_project.example.id
  agent_pool_id = azuredevops_agent_pool.this[each.key].id
}

resource "azuredevops_pipeline_authorization" "this" {
  for_each    = local.agent_pools
  project_id  = data.azuredevops_project.example.id
  resource_id = azuredevops_agent_queue.this[each.key].id
  type        = "queue"
  pipeline_id = azuredevops_build_definition.mi[0].id
}

resource "azurerm_container_group" "example" {
  for_each            = local.agents
  name                = each.value.name
  location            = var.location
  resource_group_name = azurerm_resource_group.agents.name
  ip_address_type     = "None"
  os_type             = "Linux"

  identity {
    type = "UserAssigned"
    identity_ids = [
      each.value.identity
    ]
  }

  container {
    name   = each.value.name
    image  = "jaredfholgate/azure-devops-agent:0.0.3"
    cpu    = "1"
    memory = "4"

    ports {
      port     = 80
      protocol = "TCP"
    }

    environment_variables = {
      AZP_URL            = "${var.azure_devops_organisation_prefix}/${var.azure_devops_organisation_target}"
      AZP_POOL           = each.value.pool
      AZP_AGENT_NAME     = each.value.name
      TARGET_ENVIRONMENT = each.value.environment
    }

    secure_environment_variables = {
      AZP_TOKEN = var.azure_devops_token
    }
  }
}