resource "azurerm_container_group" "alz" {
  for_each            = var.create_agents ? var.agent_container_instances : {}
  name                = each.value.container_instance_name
  location            = var.azure_location
  resource_group_name = azurerm_resource_group.agents[0].name
  ip_address_type     = "None"
  os_type             = "Linux"

  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.alz.id
    ]
  }

  container {
    name   = each.value.container_instance_name
    image  = var.agent_container_instance_image
    cpu    = "1"
    memory = "4"

    ports {
      port     = 80
      protocol = "TCP"
    }

    environment_variables = {
      AZP_URL        = var.agent_organization_url
      AZP_POOL       = var.agent_pool_name
      AZP_AGENT_NAME = each.value.agent_name
    }

    secure_environment_variables = {
      AZP_TOKEN = var.agent_token
    }
  }
}