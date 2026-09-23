# Virtual WAN customer IP consumer tests

These tests exercise the actual starter variable in `variables.connectivity.virtual.wan.tf`, the real `main.config.tf` / `modules/config-templating` path, and the `local.virtual_hubs` value passed to the Virtual WAN module. They do not duplicate the input schema or replace the config helper with an override.

`firewall_ip_configurations.tftest.hcl` checks literal and templated customer IDs, names, count strings, managed defaults, nullable maps, policy inheritance, disabled connectivity and empty hubs. Its provider-mapping assertion is a **static wiring check**, not proof of the pattern's Azure resource implementation. It also includes `multi_element_ip_configurations_survive_copied_schema_and_provider_mapping`, an Accelerator-owned propagation contract check: a 3-entry `ip_configurations` map, declared out of key order, must keep each entry's own name/ID exactly and must not be reordered, truncated, or index-biased by the starter's own copied schema, config-templating, or provider mapping. This is deliberately scoped to what a mock can prove; it is **not** evidence of how the pattern module or Azure resolve per-configuration attributes (e.g. a private IP address) from a live, heterogeneous `ipConfigurations` response after apply — that class of behavior is real-ARM-shaped and ordering-dependent, and is out of scope here by design.

The runner also requires Terraform's actual input-type conversion to reject missing `name` and `public_ip_address_id` attributes. Those cases intentionally exit nonzero; the runner checks the specific missing-field diagnostic rather than treating any failure as success.

`fixtures/computed-firewall-ip` passes a `terraform_data` output as one IP ID. Its plan checks require hub/configuration keys, names and unrelated IDs to remain known while that ID is unknown; its local apply checks the resolved ID through the starter's public `templated_inputs` output. It never accesses a child's private locals.

`nonzero_hub_topology.tftest.hcl` exercises the starter with one or more nonzero Virtual WAN hubs (not just the always-mocked zero-hub/disabled-connectivity paths above), against the pinned pattern source. It adds real `azurerm_client_config` and `azapi_resource_action` region-data mocks on the `.connectivity`-aliased providers so the pattern's own region lookup and hub-count logic actually execute, instead of relying on Terraform's synthetic auto-mocks. Three runs (`..._customer_only_firewall_focused`, `..._managed_only_firewall_focused`, `..._mixed_firewall_focused`) narrowly isolate firewall/customer-IP behavior by explicitly disabling bastion, VPN gateway, ExpressRoute gateway, private DNS zones/resolver, and the sidecar virtual network via `enabled_resources` — mirroring the pattern module's own upstream unit-test convention for isolating firewall assertions. These are deliberately scoped and must not be read as full-topology regression coverage. A fourth run, `virtual_wan_enabled_nonzero_mixed_default_on_topology`, is the full-topology positive case: two hubs (a managed Premium primary, a customer-owned Standard secondary) with every `enabled_resources` flag left at its default (`true`, i.e. bastion/VPN/ExpressRoute/DNS/sidecar all enabled) and real `bgp_settings` supplied for the VPN gateway's required config, asserting that every default-on resource flag and the firewall/customer-IP shape are simultaneously correct. A fifth run, `hub_and_spoke_topology_ignores_customer_ip_shaped_hubs`, confirms the unrelated hub-and-spoke topology stays inert when hub keys happen to look customer-shaped.

The starter configures its providers internally, so mocks in a parent fixture cannot replace them.
`Invoke-Tests.ps1` creates hard links to the actual starter `.tf` files and a directory link to its real `modules` directory in the fixture's ignored `.terraform/starter` directory. Only `terraform.tf` is replaced with test-only provider declarations, allowing explicit mock provider injection.
There is no copied input schema, forwarding implementation or template engine to drift; the links are refreshed on every invocation.

Azure providers are mocked. Connectivity and management deployment are disabled in the test inputs, not in the released scenario examples. The computed fixture's apply creates only local test state for `terraform_data`; it does not create Azure resources.
These are consumer schema/forwarding tests. They are **not** evidence that the pinned pattern release supports the new field, nor proof of Azure state migration or traffic behavior.

## Run

From the repository root with Terraform installed:

```powershell
.\templates\platform_landing_zone\tests\Invoke-Tests.ps1
terraform -chdir=templates\platform_landing_zone fmt -check -recursive
```

Use `-SkipInit` after successful initialization, or `-ComputedOnly` to run just the computed-ID fixture. The runner restores the caller's `TF_DATA_DIR` after running. The runner requires PowerShell 7+ (enforced by `#Requires -Version 7.0`) and refuses to run under Windows PowerShell 5.1 rather than silently skipping assertions.

This runner is invoked automatically in CI by `.github/workflows/accelerator-offline-tests.yml` on every pull request, on `merge_group`, and on manual `workflow_dispatch`. That job uses mocked providers only and requires no Azure credentials.

The computed fixture deliberately pins AzureRM `4.81.0` and AzAPI `2.12.0` for comparison with the historical baseline. Production provider constraints are not changed by this fixture.

On Windows, a long worktree path can exceed Git's module checkout limit. The runner uses the repository-root `.terraform` data directory for the starter and `.terraform/computed` for the fixture, both inside the worktree. It does not edit downloaded module caches.
PowerShell 7 and support for hard links on the worktree filesystem are required; directory links use Windows junctions or symbolic links on other platforms.
