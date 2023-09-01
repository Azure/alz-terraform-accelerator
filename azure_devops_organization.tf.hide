locals {
  azure_devops_organization_id = jsondecode(data.http.azure_devops_organization.response_body).instanceId
  azure_devops_base_64_pat = base64encode(":${var.azure_devops_token}")
}

data "http" "azure_devops_organization" {
  url = "https://dev.azure.com/${var.azure_devops_organisation_target}/_apis/connectionData"

  request_headers = {
    Accept        = "application/json"
    Authorization = "Basic ${local.azure_devops_base_64_pat}"
  }

  lifecycle {
    postcondition {
      condition     = tonumber(self.status_code) < 300
      error_message = "Could not retrieve member information"
    } 
  }
}

output "azure_devops_organization_id" {
  value = local.azure_devops_organization_id
}