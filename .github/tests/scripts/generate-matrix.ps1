param(
  [string]$runNumber = "999",
  [string]$rootModuleFolder = "./templates/platform_landing_zone",
  [string]$exampleFolders = "./templates/platform_landing_zone/examples"
)

$configFiles = Get-ChildItem -Path $exampleFolders -Recurse -Filter "*.tfvars" -Force

$matrix = @()

foreach($configFile in $configFiles) {

  $directory = $configFile.Directory.Name
  $configFileName = [System.IO.Path]::GetFileNameWithoutExtension($configFile.Name)

  $shortDirectory = [System.String]::Join("", ($directory.Split("-") | ForEach-Object { $_.Substring(0, 1)}))
  $shortFileName = [System.String]::Join("", ($configFileName.Split("-") | ForEach-Object { $_.Substring(0, 1)}))

  $matrixItem = @{
    name = $directory + "-" + $configFileName + "-" + $runNumber
    shortName = $shortDirectory + $shortFileName + "-" + $runNumber
    configFilePath = $configFile.FullName
    rootModuleFolderPath = $rootModuleFolder
  }
  $matrix += $matrixItem
}

return $matrix
