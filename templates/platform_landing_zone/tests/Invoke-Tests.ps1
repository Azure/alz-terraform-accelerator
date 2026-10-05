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
$dataRoot = Join-Path $env:TEMP "alz-accelerator-terraform"
$starterDataRoot = Join-Path $dataRoot "starter"
$computedDataRoot = Join-Path $dataRoot "computed"
$linkedStarter = Join-Path $fixtureRoot ".terraform\starter"
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

Copy-Item -LiteralPath (Join-Path $fixtureRoot "main.tf.template") `
  -Destination (Join-Path $fixtureRoot "main.tf") -Force

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
New-Item -ItemType HardLink -Path $providerLink `
  -Target (Join-Path $PSScriptRoot "fixtures\starter-providers\terraform.tf") | Out-Null

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
    $env:TF_DATA_DIR = $starterDataRoot
    if (-not $SkipInit) {
      Invoke-Terraform -Directory $moduleRoot -Arguments @("init", "-backend=false", "-input=false", "-no-color")
    }
    Invoke-Terraform -Directory $moduleRoot -Arguments @("test", "-no-color")
  }

  $env:TF_DATA_DIR = $computedDataRoot
  if (-not $SkipInit) {
    Invoke-Terraform -Directory $fixtureRoot -Arguments @("init", "-backend=false", "-input=false", "-no-color")
  }
  Invoke-Terraform -Directory $fixtureRoot -Arguments @("test", "-no-color")
} finally {
  $env:TF_DATA_DIR = $previousDataDirectory
}
