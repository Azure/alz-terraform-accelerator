locals {
  virtual_hubs = { for virtual_hub_key, virtual_hub_value in var.virtual_hubs : virtual_hub_key => virtual_hub_value.hub }
}
