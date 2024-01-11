data "github_organization" "alz" {
  name = var.organization_name
}

data "github_actions_organization_registration_token" "alz" {}
