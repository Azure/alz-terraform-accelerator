variable "connectivity_type" {
  type        = string
  description = "The type of network connectivity technology to use for the private DNS zones"
  default     = "hub_and_spoke_vnet"
  validation {
    condition     = contains(values(local.const.connectivity), var.connectivity_type)
    error_message = "The connectivity type must be either 'hub_and_spoke_vnet', 'virtual_wan' or 'none'"
  }
}

variable "connectivity_resource_groups" {
  type = map(object({
    name     = string
    location = string
    tags     = optional(map(string))
    settings = optional(any)
  }))
  default     = {}
  description = <<DESCRIPTION
A map of resource groups to create. These must be created before the connectivity module is applied.

The following attributes are supported:

  - name: The name of the resource group
  - location: The location of the resource group
  - settings: (Optional) An object, which can include an `enabled` setting value that indicates whether the resource group should be created.

DESCRIPTION
}

variable "connectivity_tags" {
  type        = map(string)
  default     = null
  description = "(Optional) Tags of the connectivity resources."
}

variable "ignore_body_changes" {
  type = object({
    virtual_hubs_firewalls                     = optional(list(string), [])
    virtual_hubs_firewalls_diagnostic_settings = optional(list(string), [])
    virtual_hubs_route_maps = optional(object({
      virtual_hubs_route_maps = optional(list(string), [])
    }), {})
    virtual_networks = optional(list(string), [])
    virtual_networks_subnets = optional(object({
      virtual_networks_subnets = optional(list(string), [])
    }), {})
    virtual_networks_virtual_network_peerings = optional(object({
      virtual_networks_virtual_network_peerings = optional(list(string), [])
    }), {})
  })
  default     = {}
  description = <<DESCRIPTION
(Optional) Body property paths on the resources the selected connectivity module creates through the `azapi` provider that the provider stops reconciling after creation, so an out-of-band controller such as Azure Virtual Network Manager or an Azure Policy `DeployIfNotExists` assignment can own them without producing perpetual drift. Paths use dot notation relative to the request body and cannot target individual list items.

The same object is passed to the Virtual WAN module when `connectivity_type` is `virtual_wan` and to the hub and spoke virtual network module when it is `hub_and_spoke_vnet`. Categories that the selected module does not support are ignored.

Categories used by both connectivity types:

- `virtual_networks` - (Optional) Ignored body paths for the sidecar virtual network of every virtual hub, or for every hub virtual network, for example `["tags"]` when Azure Policy applies tags out-of-band. Default `[]`.
- `virtual_networks_subnets` - (Optional) An object with the following field:
  - `virtual_networks_subnets` - (Optional) Ignored body paths applied to every sidecar subnet or hub subnet, for example `["properties.routeTable"]`. A per-subnet `ignore_body_changes` entry in `virtual_hubs.<key>.sidecar_virtual_network.subnets` or `hub_virtual_networks.<key>.hub_virtual_network.subnets` takes precedence. For a hub subnet, any value other than `null`, including an empty list, replaces this shared value. Default `[]`.

Categories used only by Virtual WAN:

- `virtual_hubs_firewalls` - (Optional) Ignored body paths for the firewall of every secured hub. The paths that carry the firewall's IP configuration and its hub association cannot be ignored, because the module reconciles them. Default `[]`.
- `virtual_hubs_firewalls_diagnostic_settings` - (Optional) Ignored body paths for the diagnostic settings of every secured hub firewall. Default `[]`.
- `virtual_hubs_route_maps` - (Optional) An object with the following field:
  - `virtual_hubs_route_maps` - (Optional) Ignored body paths applied to every route map in `route_maps`. Default `[]`.

Categories used only by hub and spoke virtual network:

- `virtual_networks_virtual_network_peerings` - (Optional) An object with the following field:
  - `virtual_networks_virtual_network_peerings` - (Optional) Ignored body paths applied to every hub-to-hub mesh peering. Default `[]`.

Leave the matching dedicated input unset for any path you ignore, because while a path is ignored, configuration changes at that path are no longer sent to Azure. The value is write-only provider state, so a change only takes effect after an `apply`, and supplying a non-empty list requires Terraform 1.11 or later.

The hub virtual networks' `properties.subnets` and `properties.virtualNetworkPeerings` are always ignored by the hub and spoke virtual network module, including on the first plan after import, so they do not need to be listed here. Virtual network peerings are not exposed for Virtual WAN, because that module connects the sidecar virtual network through the Virtual WAN hub rather than through peerings it manages itself.
DESCRIPTION
  nullable    = false

  validation {
    condition = alltrue([
      for path in concat(
        var.ignore_body_changes.virtual_hubs_firewalls,
        var.ignore_body_changes.virtual_hubs_firewalls_diagnostic_settings,
        var.ignore_body_changes.virtual_hubs_route_maps.virtual_hubs_route_maps,
        var.ignore_body_changes.virtual_networks,
        var.ignore_body_changes.virtual_networks_subnets.virtual_networks_subnets,
        var.ignore_body_changes.virtual_networks_virtual_network_peerings.virtual_networks_virtual_network_peerings
      ) : length(trimspace(path)) > 0
    ])
    error_message = "Every ignore_body_changes entry must be a non-empty body path in dot notation, for example \"properties.routeTable\" or \"tags\"."
  }
}
