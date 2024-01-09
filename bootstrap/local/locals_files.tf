locals {
  module_files = { for key, value in module.files.files : key =>
    {
      content = replace((file(value.path)), "# backend \"azurerm\" {}", var.create_seed_resources_in_azure ? "backend \"azurerm\" {}" : "backend \"local\" {}")
    } if value.flag == "module" || value.flag == "additional"
  }
}
