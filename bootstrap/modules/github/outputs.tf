output "organization_url" {
  value = local.organization_url
}

output "subjects" {
  value = local.oidc_subjects
}

output "issuer" {
  value = "https://token.actions.githubusercontent.com"
}

output "organization_users" {
  value = data.github_organization.alz.users
}

output "runner_group_names" {
  value = { for key, value in var.runner_groups : key => local.runner_group_name }
}

output "organisation_plan" {
  value = data.github_organization.alz.plan
}

output "runner_registration_token" {
  sensitive = true
  value     = data.github_actions_organization_registration_token.alz.token
}
