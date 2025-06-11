param(
  [string]$mode = "apply",
  [string]$rootModuleFolderPath = "./templates/platform_landing_zone",
  [string]$sourceVarFilePath = "./templates/platform_landing_zone/examples/full-multi-region/hub-and-spoke-vnet.tfvars",
  [int]$splitNumber = 1,
  [int]$splitIncrement = 1,
  [string]$shortName = "blah"
)

function Invoke-TerraformWithRetry {
  param(
    [hashtable[]]$commands,
    [string]$workingDirectory,
    [string]$outputLog = "output.log",
    [string]$errorLog = "error.log",
    [int]$maxRetries = 10,
    [string[]]$retryOn = @("429 Too Many Requests"),
    [switch]$printOutput
  )

  $retryCount = 1

  while ($retryCount -le $maxRetries) {
    foreach ($command in $commands) {
      $commandName = $command.Command
      $arguments = $command.Arguments
      $commandArguments = @("-chdir=$workingDirectory", $commandName) + $arguments

      Write-Host "Running Terraform $commandName with arguments: $($commandArguments -join ' ')"
      $process = Start-Process `
        -FilePath "terraform" `
        -ArgumentList $commandArguments `
        -RedirectStandardOutput $outputLog `
        -RedirectStandardError $errorLog `
        -PassThru `
        -NoNewWindow `
        -Wait

      if ($process.ExitCode -ne 0) {
        $errorOutput = Get-Content -Path $errorLog -Raw
        $shouldRetry = $false
        foreach($line in $errorOutput) {
          foreach($retryError in $retryOn) {
            if ($line -match $retryError) {
              Write-Host "Retrying Terraform $commandName due to error: $line"
              $shouldRetry = $true
              break
            }
          }
          if ($shouldRetry) {
            break
          }
        }

        if ($shouldRetry) {
          Write-Host "Retrying Terraform $commandName due to error: $errorOutput"
          $retryCount++
          break
        } else {
          Write-Host "Terraform $commandName failed with exit code $($process.ExitCode). Check the logs for details."
          Write-Host "Output Log:"
          Get-Content -Path $outputLog | Write-Host
          Write-Host "Error Log:"
          Get-Content -Path $errorLog | Write-Host
          Write-Host "Combination: $combinationNumber of $($combinations.Count)"
          Write-Host "$($updatedLines | ConvertTo-Json -Depth 10)"
          return $false
        }

      }

      if($printOutput) {
        Write-Host "Output Log:"
        Get-Content -Path $outputLog | Write-Host
      }
    }
    return $true
  }
}

$destinationVarFilePath = "$rootModuleFolderPath/test.auto.tfvars"

$fileContent = Get-Content -Path $sourceVarFilePath

Write-Host "Processing config file: $sourceVarFilePath"

$booleanConfigs = @()
foreach($line in $fileContent) {
  if($line -match "^.+_enabled\s+=\strue$") {
    Write-Host "Found boolean config: $($line)"
    $booleanConfigs += $line
  }
}

$combinations = @()
$configState = @{}

foreach($config in $booleanConfigs) {
  $configState[$config] = $true
}

foreach($config in $booleanConfigs) {
  foreach($childConfig in $booleanConfigs) {
    $combination = $configState.Clone()
    $combinations += $combination
    $configState[$childConfig] = !$configState[$childConfig]
  }
  $configState[$config] = !$configState[$config]
}

if($combinations.Count -eq 0) {
  $combinations += @{}
}

Write-Host "Found $($combinations.Count) combinations for $sourceVarFilePath"

$combinationNumber = 1
$splitCombinationNumber = $splitNumber
foreach ($combination in $combinations) {
  if($combinationNumber -ne $splitCombinationNumber) {
    $combinationNumber++
    continue
  }

  $testContent = @()
  $updatedLines = @()

  foreach ($line in $fileContent) {
    $updatedLine = $line
    if($combination.ContainsKey($line)) {
      $setting = $combination[$line].ToString().ToLower()
      $updatedLine = $line -replace "true", $setting
      $updatedLines += $updatedLine
    }
    if($mode -eq "apply" -and $updatedLine -like "*_resource_group_name*" -and $updatedLine -match "rg-") {
      $updatedLine = $updatedLine -replace "rg-", "rg-${shortName}-"
    }
    $testContent += $updatedLine
  }

  $testContent | Out-File -FilePath $destinationVarFilePath -Encoding utf8 -Force

  Write-Host "Running $mode test for combination $combinationNumber of $($combinations.Count) with settings:"
  Write-Host "$($updatedLines | ConvertTo-Json -Depth 10)"

  $success = Invoke-TerraformWithRetry `
    -commands @(
      @{
        Command = "init"
        Arguments = @()
      }
    ) `
    -workingDirectory $rootModuleFolderPath `
    -printOutput:($mode -eq "apply")

  if(-not $success) {
    Write-Host "Failed to initialize Terraform."
    return $false
  }

  if($mode -eq "plan") {
    $success = Invoke-TerraformWithRetry `
      -commands @(@{
        Command = "plan"
        Arguments = @("-out=tfplan")
      }) `
      -workingDirectory $rootModuleFolderPath

    if(-not $success) {
      Write-Host "Failed to generate plan."
      return $false
    }

    $success = Invoke-TerraformWithRetry `
      -commands @(@{
        Command = "show"
        Arguments = @("-json", "tfplan")
      }) `
      -workingDirectory $rootModuleFolderPath `
      -outputLog "tfplan.json"

    if(-not $success) {
      Write-Host "Failed to generate plan JSON."
      return $false
    }

    $planJson = Get-Content -Raw tfplan.json
    $planObject = ConvertFrom-Json $planJson -Depth 100

    $items = @{}
    foreach($change in $planObject.resource_changes) {
      $key = [System.String]::Join("-", $change.change.actions)
      if(!$items.ContainsKey($key)) {
        $items[$key] = 0
      }
      $items[$key]++
    }

    Write-Host "Plan Summary"
    Write-Host (ConvertTo-Json $items -Depth 10)
    Write-Host "Terraform plan completed successfully for combination $combinationNumber of $($combinations.Count)."
  }

  if($mode -eq "apply") {
    $applySuccess = Invoke-TerraformWithRetry `
      -commands @(
        @{
          Command = "plan"
          Arguments = @("-out=tfplan")
        },
        @{
          Command = "apply"
          Arguments = @("tfplan")
        }
      ) `
      -workingDirectory $rootModuleFolderPath `
      -printOutput

    if(-not $applySuccess) {
      Write-Host "Failed to apply Terraform."
    } else {
      Write-Host "Terraform apply completed successfully for combination $combinationNumber of $($combinations.Count)."
    }

    $destroySuccess = Invoke-TerraformWithRetry `
      -commands @(
        @{
          Command = "plan"
          Arguments = @("-destroy","-out=tfplan")
        },
        @{
          Command = "apply"
          Arguments = @("tfplan")
        }
      ) `
      -workingDirectory $rootModuleFolderPath `
      -printOutput

    if(-not $destroySuccess) {
      Write-Host "Failed to destroy Terraform resources."
    } else {
      Write-Host "Terraform destroy completed successfully for combination $combinationNumber of $($combinations.Count)."
    }

    if(-not $applySuccess -or -not $destroySuccess) {
      Write-Host "Test failed for combination $combinationNumber of $($combinations.Count)."
      return $false
    }
  }

  $combinationNumber++
  $splitCombinationNumber = $splitCombinationNumber + $splitIncrement
  Write-Debug "Next split combination number: $splitCombinationNumber"
}

return $true
