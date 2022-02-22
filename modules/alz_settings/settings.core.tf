# Configure the custom landing zones to deploy in
# addition the core resource hierarchy.
locals {
  custom_landing_zones = {}
}

# Configure the archetype config overrides to customize
# the configuration.
locals {
  archetype_config_overrides = {}
}

# Configure the Subscription ID overrides to ensure
# Subscriptions are moved into the target management
# group.
locals {
  subscription_id_overrides = {
    root           = []
    decommissioned = []
    sandboxes      = []
    landing-zones  = [] # Not recommended, put Subscriptions in child management groups.
    platform       = [] # Not recommended, put Subscriptions in child management groups.
    connectivity   = [] # Not recommended, use subscription_id_connectivity instead.
    management     = [] # Not recommended, use subscription_id_management instead.
    identity       = [] # Not recommended, use subscription_id_identity instead.
    corp           = []
    online         = []
    sap            = []
    demo-corp      = []
    demo-online    = []
    demo-sap       = []
  }

}

# Configure custom input for testing the
# template_file_variables input.
locals {
  custom_template_file_variables = {
    testStringKey = "testStringValue"
    listOfAllowedLocations = [
      "eastus",
      "eastus2",
      "westus",
      "northcentralus",
      "southcentralus",
    ]
  }
}
