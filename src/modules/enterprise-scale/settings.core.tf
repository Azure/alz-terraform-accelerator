# Configure the custom landing zones to deploy in
# addition the core resource hierarchy.
locals {
  custom_landing_zones = {
    "${local.root_id}-example" = {
      display_name               = "Example"
      parent_management_group_id = "${local.root_id}-landing-zones"
      subscription_ids           = []
      archetype_config = {
        archetype_id = "customer_example"
        parameters = {
          Deny-Resource-Locations = {
            listOfAllowedLocations = [
              "eastus",
              "westus",
              "uksouth",
              "ukwest",
            ]
          }
          Deny-RSG-Locations = {
            listOfAllowedLocations = [
              "eastus",
              "westus",
              "uksouth",
              "ukwest",
            ]
          }
        }
        access_control = {}
      }
    }
  }
}


# Configure the Subscription ID overrides to ensure
# Subscriptions are moved into the target management
# group.
locals {
  subscription_id_overrides = {
    root           = []
    decommissioned = []
    sandboxes      = []
    landing-zones  = []
    platform       = []
    connectivity   = [] # DO NOT USE - Use `subscription_id_connectivity` input variable on module instead
    management     = [] # DO NOT USE - Use `subscription_id_management` input variable on module instead
    identity       = [] # DO NOT USE - Use `subscription_id_identity` input variable on module instead
    demo-corp      = []
    demo-online    = []
    demo-sap       = []
  }
}
