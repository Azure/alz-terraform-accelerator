param(
  [string]$runNumber = "999",
  [string]$rootModuleFolder = "./templates/platform_landing_zone",
  [string]$exampleFolders = "./templates/platform_landing_zone/examples",
  [int]$splitCount = 10
)

$configFiles = Get-ChildItem -Path $exampleFolders -Recurse -Filter "*.tfvars" -Force

$matrix = @()

$configFileNumber = 1

foreach($configFile in $configFiles) {
  $directory = $configFile.Directory.Name
  $configFileName = [System.IO.Path]::GetFileNameWithoutExtension($configFile.Name)

  $shortDirectory = [System.String]::Join("", ($directory.Split("-") | ForEach-Object { $_.Substring(0, 1)}))
  $shortFileName = [System.String]::Join("", ($configFileName.Split("-") | ForEach-Object { $_.Substring(0, 1)}))

  $subscriptionName = "alz-acc-avm-test-" + ("{0:D2}" -f $configFileNumber)
  $managementGroupId = "alz-acc-avm-test-" + ("{0:D2}" -f $configFileNumber)

  $matrixItem = @{
    name = $directory + "--" + $configFileName + "-" + $runNumber + "-a"
    shortName = $shortDirectory + $shortFileName + "-" + $runNumber + "-a"
    configFilePath = $configFile.FullName
    rootModuleFolderPath = $rootModuleFolder
    splitNumber = 1
    splitIncrement = 1
    mode = "apply"
    subscriptionName = $subscriptionName
    managementGroupId = $managementGroupId
  }
  $matrix += $matrixItem

  for ($i = 0; $i -lt $splitCount; $i++) {
    $splitNumber = "{0:D2}" -f ($i + 1)
    $matrixItem = @{
      name = $directory + "--" + $configFileName + "-" + $runNumber + "-p-" + $splitNumber
      shortName = $shortDirectory + $shortFileName + "-" + $runNumber + "-p-" + $splitNumber
      configFilePath = $configFile.FullName
      rootModuleFolderPath = $rootModuleFolder
      splitNumber = $i + 1
      splitIncrement = $splitCount
      mode = "plan"
      subscriptionName = $subscriptionName
      managementGroupId = $managementGroupId
    }
    $matrix += $matrixItem
  }
}

$matrix = $matrix | Sort-Object -Property splitNumber, name

return $matrix
