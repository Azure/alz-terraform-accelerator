locals {
  azure_devops_organization_id = local.is_authentication_scheme_workload_identity_federation ? (data.http.azure_devops_organization[0].response_body).instanceId : ""
  azure_devops_base_64_pat = local.is_authentication_scheme_workload_identity_federation ? base64encode(":${var.access_token}") : ""
}

data "http" "azure_devops_organization" {
  count = local.is_authentication_scheme_workload_identity_federation ? 1 : 0
  url = "${var.organization_url}/_apis/connectionData"

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