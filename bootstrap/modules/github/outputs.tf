output "organization_url" {
  value = local.organization_url
}

output "subject" {
  value = "repo:${var.organization_name}/${var.repository_name}:ref:refs/heads/main"
}

output "issuer" {
  value = "https://token.actions.githubusercontent.com"
}

output "organization_users" {
  value = data.github_organization.alz.users
}