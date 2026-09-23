virtual_hubs = {
  primary = {
    location = "eastus"
    firewall = {
      ip_configurations = {
        primary = {
          public_ip_address_id = "/subscriptions/00000000-0000-0000-0000-000000000003/resourceGroups/rg-eus/providers/Microsoft.Network/publicIPAddresses/pip-primary"
        }
      }
    }
  }
}
