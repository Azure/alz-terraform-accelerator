<!-- markdownlint-disable first-line-h1 -->
Phase 2 of the accelerator is to run the bootstrap. Follow the steps below to do that.

## 2.1 Install the ALZ PowerShell module

The ALZ PowerShell module is used to run the bootstrap phase. It is available on the [PowerShell Gallery](https://www.powershellgallery.com/packages/ALZ/). You can install it using the following steps:

1. Open a PowerShell Core (pwsh) terminal.
2. Check if you already have the ALZ module installed  by runnung `Get-InstalledModule -Name ALZ`. You'll see something like this if it is already installed:

```powershell
Version    Name                                Repository           Description
-------    ----                                ----------           -----------
1.0.0      ALZ                                 PSGallery            Azure Landing Zones Powershell Module
```

3. If the module is already installed, run `Update-Module -Name ALZ` to ensure you have the latest version.
4. If the module is not installed, run `Install-Module -Name ALZ`.

## 2.2 Run the Bootstrap

You are now ready to run the bootstrap and setup your environment. If you want to use custom names for your resources or automate the bootstrap, please refer to our [FAQs](https://github.com/Azure/alz-terraform-accelerator/wiki/Frequently-Asked-Questions) section.

The inputs differ depending on the VCS you have chosen. Click through to the relevant page for detailed instructions:

- [Azure DevOps][wiki_quick_start_phase_2_azure_devops]
- [GitHub][wiki_quick_start_phase_2_github]
- [Local file system][wiki_quick_start_phase_2_local]

## Next Steps

Once the steps in the VCS specific section are completed, head to [Phase 3][wiki_quick_start_phase_3].

 [//]: # (************************)
 [//]: # (INSERT LINK LABELS BELOW)
 [//]: # (************************)

[wiki_quick_start_phase_2_azure_devops]: %5BUser-Guide%5D-Quick-Start-Phase-2-Azure-DevOps "Wiki - Quick Start - Phase 2 - Azure DevOps"
[wiki_quick_start_phase_2_github]:       %5BUser-Guide%5D-Quick-Start-Phase-2-GitHub "Wiki - Quick Start - Phase 2 - GitHub"
[wiki_quick_start_phase_2_local]:         %5BUser-Guide%5D-Quick-Start-Phase-2-Local "Wiki - Quick Start - Phase 2 - Local"
[wiki_quick_start_phase_3]:           %5BUser-Guide%5D-Quick-Start-Phase-3 "Wiki - Quick Start - Phase 3"
