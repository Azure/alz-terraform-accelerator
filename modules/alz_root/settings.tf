# Obtain configuration settings.
module "settings" {
  source = "../alz_settings"

  root_id                = var.root_id
  primary_location       = var.primary_location
  secondary_location     = var.secondary_location
  email_security_contact = var.email_security_contact
  environment            = var.environment
}
