# Platform landing zone offline tests

Run the tests from the repository root with Terraform and PowerShell 7 installed:

```powershell
.\templates\platform_landing_zone\tests\Invoke-Tests.ps1
```

The runner tests the real platform landing zone inputs with mocked providers. This covers policy override token replacement and defaults, and the interim ALZ telemetry content planned through the real ALZ module's deployment-name check.
The module version token is unresolved in these tests, so the name check is one character looser than in production.
The runner then tests apply-time customer public IP IDs through an HCL consumer fixture. No Azure credentials are required.
These tests do not prove an existing deployment's state upgrade. To run only the apply-time ID fixture, use:

```powershell
.\templates\platform_landing_zone\tests\Invoke-Tests.ps1 -ComputedOnly
```
