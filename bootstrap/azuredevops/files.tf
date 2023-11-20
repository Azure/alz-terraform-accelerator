locals {
  starter_module_path = abspath("${path.module}/${var.template_folder_path}/${var.starter_module}")
  ci_cd_module_path   = abspath("${path.module}/${var.template_folder_path}/${var.ci_cd_module}")
}

module "starter_module_files" {
  source      = "./../modules/files"
  folder_path = local.starter_module_path
  flag        = "module"
}

module "ci_cd_module_files" {
  source      = "./../modules/files"
  folder_path = local.ci_cd_module_path
  include     = ".azuredevops/**"
  flag        = "cicd"
}

module "ci_cd_module_template_files" {
  source      = "./../modules/files"
  folder_path = local.ci_cd_module_path
  include     = ".templates/.azuredevops/**"
  flag        = "cicd_templates"
}

locals {
  starter_module_repo_files = merge(module.starter_module_files.files, module.ci_cd_module_files.files, module.ci_cd_module_template_files.files)
  additional_repo_files = { for file in var.additional_files : basename(file) => {
    path = file
    flag = "additional"
    }
  }
  all_repo_files = merge(local.starter_module_repo_files, local.additional_repo_files)
}
