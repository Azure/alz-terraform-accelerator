#Requires -Version 7.0
[CmdletBinding()]
param(
  [switch]$SkipInit,
  [switch]$ComputedOnly
)

$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $false
$moduleRoot = Split-Path -Parent $PSScriptRoot
$repositoryRoot = & git -C $moduleRoot rev-parse --show-toplevel
if ($LASTEXITCODE -ne 0) {
  throw "Run these tests from a Git working tree so all generated files stay inside it."
}
$repositoryRoot = (Resolve-Path $repositoryRoot).Path
$fixtureRoot = Join-Path $PSScriptRoot "fixtures\computed-firewall-ip"
$linkedStarter = Join-Path $fixtureRoot ".terraform\starter"
$dataRoot = Join-Path $repositoryRoot ".terraform"
$previousDataDirectory = $env:TF_DATA_DIR

function Invoke-Terraform {
  param(
    [string]$Directory,
    [string[]]$Arguments
  )

  & terraform "-chdir=$Directory" @Arguments
  if ($LASTEXITCODE -ne 0) {
    throw "terraform $($Arguments -join ' ') failed in $Directory (exit $LASTEXITCODE)."
  }
}

# Child-owned provider configurations cannot be mocked by a Terraform test wrapper.
# Link the real starter files, replacing only provider declarations for this fixture.
New-Item -ItemType Directory -Path $linkedStarter -Force | Out-Null
$sourceFiles = Get-ChildItem -LiteralPath $moduleRoot -Filter "*.tf" -File |
  Where-Object Name -NE "terraform.tf"
foreach ($sourceFile in $sourceFiles) {
  $link = Join-Path $linkedStarter $sourceFile.Name
  if (Test-Path -LiteralPath $link) {
    Remove-Item -LiteralPath $link
  }
  New-Item -ItemType HardLink -Path $link -Target $sourceFile.FullName | Out-Null
}

$providerLink = Join-Path $linkedStarter "terraform.tf"
if (Test-Path -LiteralPath $providerLink) {
  Remove-Item -LiteralPath $providerLink
}
New-Item -ItemType HardLink -Path $providerLink -Target (Join-Path $PSScriptRoot "fixtures\starter-providers\terraform.tf") | Out-Null

$modulesLink = Join-Path $linkedStarter "modules"
$modulesSource = Join-Path $moduleRoot "modules"
if (Test-Path -LiteralPath $modulesLink) {
  $existingLink = Get-Item -LiteralPath $modulesLink
  if ($existingLink.LinkType -notin @("Junction", "SymbolicLink") -or $existingLink.Target -ne $modulesSource) {
    throw "Refusing to replace an unexpected modules path at $modulesLink."
  }
} else {
  $linkType = if ($IsWindows -eq $true -or $env:OS -eq "Windows_NT") { "Junction" } else { "SymbolicLink" }
  New-Item -ItemType $linkType -Path $modulesLink -Target $modulesSource | Out-Null
}

try {
  if (-not $ComputedOnly) {
    $env:TF_DATA_DIR = $dataRoot
    if (-not $SkipInit) {
      Invoke-Terraform -Directory $moduleRoot -Arguments @("init", "-backend=false", "-input=false", "-no-color")
    }
    Invoke-Terraform -Directory $moduleRoot -Arguments @("test", "-no-color")

    $invalidCases = @(
      @{ File = "missing-name.tfvars"; Attribute = "name" },
      @{ File = "missing-public-ip-id.tfvars"; Attribute = "public_ip_address_id" }
    )
    foreach ($invalidCase in $invalidCases) {
      $diagnostics = & terraform "-chdir=$moduleRoot" test "-test-directory=tests/schema" "-var-file=tests/fixtures/invalid-ip-configurations/$($invalidCase.File)" "-no-color" 2>&1 | Out-String
      # Terraform hard-wraps diagnostics at the terminal width and interleaves test
      # progress lines into them, so match a flattened copy with the progress lines
      # removed rather than the raw output.
      $flattened = (($diagnostics -split "\r?\n" | Where-Object { $_ -notmatch "\.\.\.\s*(in progress|tearing down|pass|fail)\s*$" }) -join " ") -replace "\s+", " "
      if ($LASTEXITCODE -eq 0 -or $flattened -notmatch "var\.virtual_hubs" -or $flattened -notmatch "attribute `"$($invalidCase.Attribute)`" is required") {
        Write-Host $diagnostics
        throw "Expected the actual starter schema to reject $($invalidCase.File) for its missing required field."
      }
      Write-Host "Schema rejection passed: $($invalidCase.File)"
    }
  }

  $env:TF_DATA_DIR = Join-Path $dataRoot "computed"
  if (-not $SkipInit) {
    Invoke-Terraform -Directory $fixtureRoot -Arguments @("init", "-backend=false", "-input=false", "-no-color")
  }
  Invoke-Terraform -Directory $fixtureRoot -Arguments @("test", "-no-color")
} finally {
  $env:TF_DATA_DIR = $previousDataDirectory
}
