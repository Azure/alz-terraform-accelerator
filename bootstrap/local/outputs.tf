output "module_output_directory_path" {
  description = "The path to the directory where the module files have been created."
  value       = abspath(local.target_directory)
}
