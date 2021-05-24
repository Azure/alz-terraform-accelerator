# The following output gives the a summary of all resources
# created by the enterprise_scale module, formatted to allow
# easy identification of the resource IDs as stored in the
# Terraform state.

output "resource_ids" {
  value = {
    core = {
      for key, value in module.es_core :
      key => {
        enterprise_scale = keys(value.enterprise_scale)
      }
    }
    management = {
      for key, value in module.es_mgmt :
      key => {
        enterprise_scale = keys(value.enterprise_scale)
      }
    }
  }
}
