param(
  [string]$runNumber = "999",
  [string]$rootModuleFolder = "./templates/platform_landing_zone",
  [string]$exampleFolders = "./templates/platform_landing_zone/examples",
  [int]$splitCount = 10
)

$configFiles = Get-ChildItem -Path $exampleFolders -Recurse -Filter "*.tfvars" -Force

$matrix = @()

foreach($configFile in $configFiles) {

  $directory = $configFile.Directory.Name
  $configFileName = [System.IO.Path]::GetFileNameWithoutExtension($configFile.Name)

  $shortDirectory = [System.String]::Join("", ($directory.Split("-") | ForEach-Object { $_.Substring(0, 1)}))
  $shortFileName = [System.String]::Join("", ($configFileName.Split("-") | ForEach-Object { $_.Substring(0, 1)}))

  for ($i = 0; $i -lt $splitCount; $i++) {
    $splitNumber = "{0:D2}" -f ($i + 1)
    $matrixItem = @{
      name = $directory + "--" + $configFileName + "-" + $runNumber + "-" + $splitNumber
      shortName = $shortDirectory + $shortFileName + "-" + $runNumber + "-" + $splitNumber
      configFilePath = $configFile.FullName
      rootModuleFolderPath = $rootModuleFolder
      splitNumber = $i + 1
      splitIncrement = $splitCount
    }
    $matrix += $matrixItem
  }
}

$matrix = $matrix | Sort-Object -Property splitNumber, name

return $matrix
