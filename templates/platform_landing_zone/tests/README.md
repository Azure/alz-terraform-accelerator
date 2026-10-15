# Virtual WAN offline tests

Run the tests from the repository root with Terraform and PowerShell 7 installed:

```powershell
.\templates\platform_landing_zone\tests\Invoke-Tests.ps1
```

The runner tests the real platform landing zone inputs with mocked providers, then tests apply-time customer public IP IDs through an HCL consumer fixture. No Azure credentials are required. To run only the apply-time ID fixture, use:

```powershell
.\templates\platform_landing_zone\tests\Invoke-Tests.ps1 -ComputedOnly
```
