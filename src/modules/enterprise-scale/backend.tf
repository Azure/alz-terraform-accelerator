terraform {
  backend "remote" {
    organization = "krowlandson"

    workspaces {
      name = "tfes-accelerator"
    }
  }
}
