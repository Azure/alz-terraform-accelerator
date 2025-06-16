param(
  [string]$runNumber = "999",
  [string]$rootModuleFolder = "./templates/platform_landing_zone",
  [string]$exampleFolders = "./templates/platform_landing_zone/examples",
  [int]$splitCount = 10,
  [string]$subscriptionNamePrefix = "alz-acc-avm-test-",
  [string]$managementGroupIdPrefix = "alz-acc-avm-test-",
  [string]$subscriptionNameSuffixNumberLength = 2,
  [string]$managementGroupIdSuffixNumberLength = 2,
  [string]$primaryTestMode = "apply",
  [string]$secondaryTestMode = "plan",
  [switch]$includeSecondaryTests
)

$configFiles = Get-ChildItem -Path $exampleFolders -Recurse -Filter "*.tfvars" -Force

$matrix = @()

$configFileNumber = 1

foreach($configFile in $configFiles) {
  $directory = $configFile.Directory.Name
  $configFileName = [System.IO.Path]::GetFileNameWithoutExtension($configFile.Name)

  $shortDirectory = [System.String]::Join("", ($directory.Split("-") | ForEach-Object { $_.Substring(0, 1)}))
  $shortFileName = [System.String]::Join("", ($configFileName.Split("-") | ForEach-Object { $_.Substring(0, 1)}))

  $subscriptionName = $subscriptionNamePrefix + ("{0:D$subscriptionNameSuffixNumberLength}" -f $configFileNumber)
  $managementGroupId = $managementGroupIdPrefix + ("{0:D$managementGroupIdSuffixNumberLength}" -f $configFileNumber)

  $matrixItem = @{
    name = $directory + "--" + $configFileName + "-" + $runNumber + "-a"
    shortName = $shortDirectory + $shortFileName + "-" + $runNumber + "-a"
    configFilePath = $configFile.FullName
    rootModuleFolderPath = $rootModuleFolder
    splitNumber = 1
    splitIncrement = 0
    mode = $primaryTestMode
    subscriptionNameConnectivity = "$subscriptionName-connectivity"
    subscriptionNameManagement = "$subscriptionName-management"
    subscriptionNameIdentity = "$subscriptionName-identity"
    managementGroupId = $managementGroupId
  }
  $matrix += $matrixItem

  if(!$includeSecondaryTests) {
    continue
  }

  for ($i = 0; $i -lt $splitCount; $i++) {
    $splitNumber = "{0:D2}" -f ($i + 1)
    $matrixItem = @{
      name = $directory + "--" + $configFileName + "-" + $runNumber + "-p-" + $splitNumber
      shortName = $shortDirectory + $shortFileName + "-" + $runNumber + "-p-" + $splitNumber
      configFilePath = $configFile.FullName
      rootModuleFolderPath = $rootModuleFolder
      splitNumber = $i + 1
      splitIncrement = $splitCount
      mode = $secondaryTestMode
      subscriptionNameConnectivity = "$subscriptionName-connectivity"
      subscriptionNameManagement = "$subscriptionName-management"
      subscriptionNameIdentity = "$subscriptionName-identity"
      managementGroupId = $managementGroupId
    }
    $matrix += $matrixItem
  }
  $configFileNumber++
}

$matrix = $matrix | Sort-Object -Property mode, splitNumber, name

return $matrix
