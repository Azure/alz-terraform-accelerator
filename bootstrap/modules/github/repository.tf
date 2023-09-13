resource "github_repository" "alz" {
  name        = var.repository_name
  description = var.repository_name
  auto_init   = true
  visibility = "private"
}

locals {
  cicd_file = { for key, value in var.repository_files : key =>
    {
      content = templatefile(value.path, {
        environment_name_plan    = var.environment_name_plan
        environment_name_apply   = var.environment_name_apply
      })
    } if value.flag == "cicd"
  }
  module_files = { for key, value in var.repository_files : key =>
    {
      content = replace((file(value.path)), "# backend \"azurerm\" {}", "backend \"azurerm\" {}")
    } if value.flag == "module"
  }
  repository_files = merge(local.cicd_file, local.module_files)
}

resource "github_repository_file" "alz" {
  for_each            = local.repository_files
  repository          = github_repository.alz.name
  file                = each.key
  content             = each.value.content
  commit_author       = "Azure Landing Zone"
  commit_email        = "alz@microsoft.com"
  overwrite_on_create = true
}