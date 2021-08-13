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

# Configure the archetype config overrides to customize
# the configuration. This repository comes pre-populated
# with default values, as specified in the module.
# Uncomment any you want to update.
locals {
  archetype_config_overrides = {
    # root = {
    #   archetype_id   = "es_root"
    #   parameters     = {}
    #   access_control = {}
    # }
    # decommissioned = {
    #   archetype_id   = "es_decommissioned"
    #   parameters     = {}
    #   access_control = {}
    # }
    # sandboxes = {
    #   archetype_id   = "es_sandboxes"
    #   parameters     = {}
    #   access_control = {}
    # }
    # landing-zones = {
    #   archetype_id   = "es_landing_zones"
    #   parameters     = {}
    #   access_control = {}
    # }
    # platform = {
    #   archetype_id   = "es_platform"
    #   parameters     = {}
    #   access_control = {}
    # }
    # connectivity = {
    #   archetype_id   = "es_connectivity"
    #   parameters     = {}
    #   access_control = {}
    # }
    # management = {
    #   archetype_id   = "es_management"
    #   parameters     = {}
    #   access_control = {}
    # }
    # identity = {
    #   archetype_id   = "es_identity"
    #   parameters     = {}
    #   access_control = {}
    # }
    # corp = {
    #   archetype_id   = "es_corp"
    #   parameters     = {}
    #   access_control = {}
    # }
    # online = {
    #   archetype_id   = "es_online"
    #   parameters     = {}
    #   access_control = {}
    # }
    # sap = {
    #   archetype_id   = "es_sap"
    #   parameters     = {}
    #   access_control = {}
    # }
    # demo-corp = {
    #   archetype_id   = "es_corp"
    #   parameters     = {}
    #   access_control = {}
    # }
    # demo-online = {
    #   archetype_id   = "es_online"
    #   parameters     = {}
    #   access_control = {}
    # }
    # demo-sap = {
    #   archetype_id   = "es_sap"
    #   parameters     = {}
    #   access_control = {}
    # }
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
    corp           = []
    online         = []
    sap            = []
    demo-corp      = []
    demo-online    = []
    demo-sap       = []
  }
}
