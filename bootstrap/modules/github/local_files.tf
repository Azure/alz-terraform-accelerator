locals {
  cicd_file = { for key, value in var.repository_files : key =>
    {
      content = templatefile(value.path, {
        organization_name         = var.organization_name
        repository_name_templates = local.repository_name_templates
        ci_template_path          = var.pipeline_templates["ci"].target_path
        cd_template_path          = var.pipeline_templates["cd"].target_path
      })
    } if value.flag == "pipeline"
  }
  cicd_template_files = { for key, value in var.repository_files : key =>
    {
      content = templatefile(value.path, {
        environment_name_plan                        = var.environments[local.plan_key]
        environment_name_apply                       = var.environments[local.apply_key]
        backend_azure_storage_account_container_name = var.backend_azure_storage_account_container_name
      })
    } if value.flag == "pipeline_template"
  }
  module_files = { for key, value in var.repository_files : key =>
    {
      content = replace((file(value.path)), "# backend \"azurerm\" {}", "backend \"azurerm\" {}")
    } if value.flag == "module" || value.flag == "additional"
  }
  repository_files = merge(local.cicd_file, local.module_files, var.use_template_repository ? {} : local.cicd_template_files)
}
