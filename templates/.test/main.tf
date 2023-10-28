data "azurerm_client_config" "current" {}
data "azurerm_subscription" "current" {}

data "azurerm_management_group" "example_parent" {
  display_name = var.parent_management_group_display_name
}

resource "azurerm_management_group" "example_child" {
  name                       = var.child_management_group_name
  display_name               = var.child_management_group_display_name
  parent_management_group_id = data.azurerm_management_group.example_parent.id
}

resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.resource_group_location
}
