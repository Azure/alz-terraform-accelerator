# Powershell verison of the installer script for testing purposes
# Scripts cannot be called from template repos in Azure DevOps, so we have to inline this script in the task
# See here for more details: https://learn.microsoft.com/en-us/azure/devops/pipelines/process/templates?view=azure-devops&pivots=templates-includes#use-other-repositories
param(
  [string]$TF_VERSION = "latest",
  [string]$TOOLS_PATH = ".\terraform"
)

if($TF_VERSION -eq "latest") {
  $TF_VERSION = (Invoke-WebRequest -Uri "https://checkpoint-api.hashicorp.com/v1/check/terraform").Content | ConvertFrom-Json | Select -ExpandProperty current_version
}

$commandDetails = Get-Command -Name terraform -ErrorAction SilentlyContinue
if($commandDetails) {
  Write-Host "Terraform already installed in $($commandDetails.Path), checking version"
  $installedVersion = terraform version -json | ConvertFrom-Json
  Write-Host "Installed version: $($installedVersion.terraform_version) on $($installedVersion.platform)"
  if($installedVersion.terraform_version -eq $TF_VERSION) {
    Write-Host "Installed version matches required version $TF_VERSION, skipping install"
    return
  }
}

$unzipdir = Join-Path -Path $TOOLS_PATH -ChildPath "terraform_$TF_VERSION"
if (Test-Path $unzipdir) {
  Write-Host "Terraform $TF_VERSION already installed."
  if($os -eq "windows") {
    $env:PATH = "$($unzipdir);$env:PATH"
  } else {
    $env:PATH = "$($unzipdir):$env:PATH"
  }
  Write-Host "##vso[task.setvariable variable=PATH]$env:PATH"
  return
}

$os = ""
if ($IsWindows) {
  $os = "windows"
}
if($IsLinux) {
  $os = "linux"
}
if($IsMacOS) {
  $os = "darwin"
}

# Enum values can be seen here: https://learn.microsoft.com/en-us/dotnet/api/system.runtime.interopservices.architecture?view=net-7.0#fields
$architecture = ([System.Runtime.InteropServices.RuntimeInformation]::OSArchitecture).ToString().ToLower()

if($architecture -eq "x64") {
  $architecture = "amd64"
}
if($architecture -eq "x86") {
  $architecture = "386"
}

$osAndArchitecture = "$($os)_$($architecture)"

$supportedOsAndArchitectures = @(
  "darwin_amd64",
  "darwin_arm64",
  "linux_386",
  "linux_amd64",
  "linux_arm64",
  "windows_386",
  "windows_amd64"
)

if($supportedOsAndArchitectures -notcontains $osAndArchitecture) {
  Write-Error "Unsupported OS and architecture combination: $osAndArchitecture"
  exit 1
}

$zipfilePath = "$unzipdir.zip"

$url = "https://releases.hashicorp.com/terraform/$($TF_VERSION)/terraform_$($TF_VERSION)_$($osAndArchitecture).zip"

if(!(Test-Path $TOOLS_PATH)) {
  New-Item -ItemType Directory -Path $TOOLS_PATH| Out-String | Write-Verbose
}

Invoke-WebRequest -Uri $url -OutFile "$zipfilePath" | Out-String | Write-Verbose

Expand-Archive -Path $zipfilePath -DestinationPath $unzipdir

$toolFileName = "terraform"

if($os -eq "windows") {
  $toolFileName = "$($toolFileName).exe"
}

$toolFilePath = Join-Path -Path $unzipdir -ChildPath $toolFileName

if($os -ne "windows") {
    $isExecutable = $(test -x $toolFilePath; 0 -eq $LASTEXITCODE)
    if(!($isExecutable)) {
      chmod +x $toolFilePath
    }
}

if($os -eq "windows") {
  $env:PATH = "$($unzipdir);$env:PATH"
} else {
  $env:PATH = "$($unzipdir):$env:PATH"
}
Write-Host "##vso[task.setvariable variable=PATH]$env:PATH"
Remove-Item $zipfilePath
Write-Host "Installed Terraform version $TF_VERSION"
