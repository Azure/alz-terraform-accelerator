# The following locals are used to convert provided input
# variables to locals before use elsewhere in the module
locals {
  root_id                         = var.root_id
  root_name                       = var.root_name
  default_location                = var.default_location
  deploy_demo_landing_zones       = var.deploy_demo_landing_zones
  deploy_corp_landing_zones       = var.deploy_corp_landing_zones
  deploy_online_landing_zones     = var.deploy_online_landing_zones
  deploy_sap_landing_zones        = var.deploy_sap_landing_zones
  deploy_management_resources     = var.deploy_management_resources
  management_resources_location   = var.management_resources_location
  security_contact_email_address  = var.security_contact_email_address
  deploy_connectivity_resources   = var.deploy_connectivity_resources
  connectivity_resources_location = var.connectivity_resources_location
}
