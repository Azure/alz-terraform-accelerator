resource "github_repository" "example" {
  name        = "${var.prefix}-${random_pet.example.id}"
  description = "Example repository ${random_pet.example.id}"
  auto_init   = false

  template {
    owner      = var.github_organisation_template
    repository = var.github_repository_template
  }
}