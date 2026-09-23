# Virtual WAN customer IP consumer tests

These tests exercise the starter's own path: the variable declared in
`variables.connectivity.virtual.wan.tf`, the real `main.config.tf` and
`modules/config-templating`, and the `local.virtual_hubs` value handed to the
Virtual WAN module. Nothing is stubbed with an override.

Azure providers are mocked, so no credentials are needed. These are consumer
schema and forwarding tests. They are not evidence of how the pattern module or
Azure behave after apply.

## Test files

`firewall_ip_configurations.tftest.hcl` covers literal and templated customer
IDs, names, count strings, managed defaults, nullable maps, policy inheritance,
disabled connectivity and empty hubs. One run checks that a 3-entry map declared
out of key order keeps each entry's own name and ID, and is not reordered,
truncated or index-biased by the starter's copied schema.

`nonzero_hub_topology.tftest.hcl` runs the starter with real Virtual WAN hubs
against the pinned pattern source, adding region-data mocks so the pattern's own
hub-count logic executes. Three runs isolate firewall behaviour by disabling
unrelated resources; a fourth leaves every `enabled_resources` flag at its
default; a fifth confirms hub-and-spoke stays inert. This is scoped coverage,
not full-topology regression.

`fixtures/computed-firewall-ip` passes an apply-time-unknown IP ID. Its plan
checks require hub keys, configuration keys, names and unrelated IDs to stay
known while that one ID is unknown.

The runner also requires Terraform's input-type conversion to reject a missing
`name` or `public_ip_address_id`. Those cases exit nonzero by design, and the
runner matches the specific diagnostic rather than accepting any failure.

## Why a runner is needed

The starter configures its providers internally, so a parent fixture cannot
replace them. `Invoke-Tests.ps1` hard-links the real starter `.tf` files and
links its `modules` directory into the fixture's ignored `.terraform/starter`,
replacing only `terraform.tf` with test-only provider declarations. Links are
refreshed every run, so there is no copied schema to drift.

## Run

From the repository root, with Terraform installed:

```powershell
.\templates\platform_landing_zone\tests\Invoke-Tests.ps1
terraform -chdir=templates\platform_landing_zone fmt -check -recursive
```

Use `-SkipInit` after a successful initialization, or `-ComputedOnly` for just
the computed-ID fixture. PowerShell 7 or later is required and enforced.

CI runs this automatically via `.github/workflows/accelerator-offline-tests.yml`
on pull requests, `merge_group` and manual dispatch. That job also verifies the
pinned pattern module actually declares `firewall.ip_configurations`, because
Terraform silently discards object attributes a module does not declare.
