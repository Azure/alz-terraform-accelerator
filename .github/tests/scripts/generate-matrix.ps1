param(
  [string]$runNumber = "999",
  [string]$rootModuleFolder = "./templates/platform_landing_zone",
  [string]$exampleFolders = "./templates/platform_landing_zone/examples"
)

$configFiles = Get-ChildItem -Path $exampleFolders -Recurse -Filter "*.tfvars" -Force

$matrix = @()

function Recurse-Config {
  param (
    [array]$booleanConfigs
  )
}

foreach($configFile in $configFiles) {

  $directory = $configFile.Directory.Name
  $configFileName = [System.IO.Path]::GetFileNameWithoutExtension($configFile.Name)

  $shortDirectory = [System.String]::Join("", ($directory.Split("-") | ForEach-Object { $_.Substring(0, 1)}))
  $shortFileName = [System.String]::Join("", ($configFileName.Split("-") | ForEach-Object { $_.Substring(0, 1)}))

  $fileContent = Get-Content -Path $configFile.FullName

  Write-Host "Processing config file: $($configFile.FullName)"

  $booleanConfigs = @()
  foreach($line in $fileContent) {
    if($line -match "^.+_enabled\s+=\strue$") {
      Write-Host "Found boolean config: $($line)"
      $booleanConfigs += $line
    }
  }

  $everyCombination = @()
  $configState = @{}

  foreach($config in $booleanConfigs) {
    $configState[$config] = $true
  }

  foreach($config in $booleanConfigs) {
    foreach($childConfig in $booleanConfigs) {
      $combination = $configState.Clone()
      $everyCombination += $combination
      $configState[$childConfig] = !$configState[$childConfig]
    }
    $configState[$config] = !$configState[$config]
  }

  Write-Host "Found $($everyCombination.Count) combinations for $($configFile.FullName)"

  $matrixItem = @{
    name = $directory + "-" + $configFileName + "-" + $runNumber
    shortName = $shortDirectory + $shortFileName + "-" + $runNumber
    configFilePath = $configFile.FullName
    rootModuleFolderPath = $rootModuleFolder
    combinations = $everyCombination
  }
  $matrix += $matrixItem
}

return $matrix
