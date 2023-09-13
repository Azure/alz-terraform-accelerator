output "organization_url" {
  value = local.organization_url
}

output "subject" {
  value = "TBC"
}

output "issuer" {
  value = "TBC"
}

output "organization_users" {
  value = data.github_organization.alz.users
}