# The following output gives the a summary of all resources
# created by the enterprise_scale module, formatted to allow
# easy identification of the resource IDs as stored in the
# Terraform state.

output "resource_ids" {
  value = {
    for module_name, module_output in {
      enterprise_scale = module.enterprise_scale
    } :
    module_name => {
      for resource_type, resource_instances in module_output :
      resource_type => {
        for resource_name, resource_configs in resource_instances :
        resource_name => keys(resource_configs)
      }
    }
  }
}
