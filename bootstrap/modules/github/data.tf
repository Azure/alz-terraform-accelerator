data "github_organization" "alz" {
  name = var.organization_name
}

data "github_actions_organization_registration_token" "alz" {}

data "github_actions_registration_token" "alz" {
  repository = github_repository.alz.name
}
