locals {
  private_dns_secondary_zones = {
    azure_data_explorer = {
      zone_name = "privatelink.{regionName}.kusto.windows.net"
    }
    azure_batch_account = {
      zone_name = "{regionName}.privatelink.batch.azure.com"
    }
    azure_batch_node_mgmt = {
      zone_name = "{regionName}.service.privatelink.batch.azure.com"
    }
    azure_aks_mgmt = {
      zone_name = "privatelink.{regionName}.azmk8s.io"
    }
    azure_acr_data = {
      zone_name = "{regionName}.data.privatelink.azurecr.io"
    }
    azure_backup = {
      zone_name = "privatelink.{regionCode}.backup.windowsazure.com"
    }
  }
}
