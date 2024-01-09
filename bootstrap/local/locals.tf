# Resource Name Setup
locals {
  resource_names = module.resource_names.resource_names
}

locals {
  plan_key  = "plan"
  apply_key = "apply"
}

locals {
  managed_identities = {
    (local.plan_key)  = local.resource_names.user_assigned_managed_identity_plan
    (local.apply_key) = local.resource_names.user_assigned_managed_identity_apply
  }

  federated_credentials = var.federated_credentials
}

locals {
  starter_module_folder_path = var.module_folder_path_relative ? ("${path.module}/${var.module_folder_path}/${var.starter_module}") : "${var.module_folder_path}/${var.starter_module}"
}

locals {
  target_directory = var.target_directory == "" ? ("${path.module}/${var.default_target_directory}") : var.target_directory
}