virtual_hubs = {
  primary = {
    location = "eastus"
    firewall = {
      ip_configurations = {
        primary = {
          name = "ipconfig-primary"
        }
      }
    }
  }
}
