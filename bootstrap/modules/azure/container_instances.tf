resource "azurerm_container_group" "alz" {
  for_each            = var.agent_container_instances
  name                = each.value.container_instance_name
  location            = var.azure_location
  resource_group_name = azurerm_resource_group.agents[0].name
  ip_address_type     = var.use_private_networking ? "Private" : "None"
  os_type             = "Linux"
  subnet_ids          = var.use_private_networking ? [azurerm_subnet.container_instances[0].id] : []

  dynamic "identity" {
    for_each = each.value.attach_managed_identity ? [1] : []
    content {
      type = "UserAssigned"
      identity_ids = [
        azurerm_user_assigned_identity.alz[each.value.managed_identity_key].id
      ]
    }
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
      (var.agent_organization_environment_variable) = var.agent_organization_url
      (var.agent_pool_environment_variable)         = each.value.agent_pool_name
      (var.agent_name_environment_variable)         = each.value.agent_name
    }

    secure_environment_variables = {
      (var.agent_token_environment_variable) = var.agent_token
    }
  }
}
