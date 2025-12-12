param(
  [string]$mode = "apply",
  [string]$rootModuleFolderPath = "./templates/platform_landing_zone",
  [string]$sourceVarFilePath = "./templates/platform_landing_zone/examples/full-multi-region/hub-and-spoke-vnet.tfvars",
  [int]$splitNumber = 1,
  [int]$splitIncrement = 1,
  [string]$shortName = "blah",
  [string]$logFolder = "./logs"
)

function Invoke-TerraformWithRetry {
  param(
    [hashtable[]]$commands,
    [string]$workingDirectory,
    [string]$outputLog = "output.log",
    [string]$errorLog = "error.log",
    [int]$maxRetries = 10,
    [int]$retryDelayIncremental = 10,
    [string[]]$retryOn = @("429 Too Many Requests"),
    [switch]$printOutput,
    [switch]$printOutputOnError
  )

  $retryCount = 0
  $shouldRetry = $true

  while ($shouldRetry -and $retryCount -le $maxRetries) {
    $shouldRetry = $false

    foreach ($command in $commands) {
      $commandName = $command.Command
      $arguments = $command.Arguments

      $localLogPath = $outputLog
      if($command.OutputLog) {
        $localLogPath = $command.OutputLog
      }

      $commandArguments = @("-chdir=$workingDirectory", $commandName) + $arguments

      Write-Host "Running Terraform $commandName with arguments: $($commandArguments -join ' ')"
      $process = Start-Process `
        -FilePath "terraform" `
        -ArgumentList $commandArguments `
        -RedirectStandardOutput $localLogPath `
        -RedirectStandardError $errorLog `
        -PassThru `
        -NoNewWindow `
        -Wait

      if ($process.ExitCode -ne 0) {
        Write-Host "Terraform $commandName failed with exit code $($process.ExitCode)."

        if($retryOn -contains "*") {
          $shouldRetry = $true
        } else {
          $errorOutput = Get-Content -Path $errorLog
          foreach($line in $errorOutput) {
            foreach($retryError in $retryOn) {
              if ($line -like "*$retryError*") {
                Write-Host "Retrying Terraform $commandName due to error: $line"
                $shouldRetry = $true
              }
            }
          }
        }

        if ($shouldRetry) {
          Write-Host "Retrying Terraform $commandName due to error:"
          Get-Content -Path $errorLog | Write-Host
          $retryCount++
          break
        } else {
          Write-Host "Terraform $commandName failed with exit code $($process.ExitCode). Check the logs for details."
          if($printOutputOnError) {
            Write-Host "Output Log:"
            Get-Content -Path $localLogPath | Write-Host
          }
          Write-Host "Error Log:"
          Get-Content -Path $errorLog | Write-Host
          return $false
        }
      } else {
        if($printOutput) {
          Write-Host "Output Log:"
          Get-Content -Path $localLogPath | Write-Host
        }
      }
    }
    if ($shouldRetry) {
      Write-Host "Retrying Terraform commands (attempt $retryCount of $maxRetries)..."
      $retryDelay = $retryDelayIncremental * $retryCount
      Write-Host "Waiting for $retryDelay seconds before retrying..."
      Start-Sleep -Seconds $retryDelay
    }
  }
  return $true
}

$destinationVarFilePath = "$rootModuleFolderPath/test.auto.tfvars"

$fileContent = Get-Content -Path $sourceVarFilePath

if(-not (Test-Path -Path $logFolder)) {
  New-Item -ItemType Directory -Path $logFolder | Out-Null
}

Write-Host "Processing config file: $sourceVarFilePath"

$booleanConfigs = @()
foreach($line in $fileContent) {
  if($line -match "^.+_enabled\s+=\strue$" -and -not $line.TrimStart().StartsWith("#")) {
    Write-Host "Found boolean config: $($line)"
    $booleanConfigs += $line
  }
}

$combinations = @()

$configSplits = @("secondary_", "primary_")

foreach($configSplit in $configSplits) {
  $filteredConfigs = $booleanConfigs | Where-Object { $_ -notlike "*$configSplit*" }
  $filteredConfigsConfigLength = $filteredConfigs.Count
  if($filteredConfigsConfigLength -le 1) {
    Write-Host "No boolean configs found for split '$configSplit'. Skipping."
    continue
  }
  $filteredConfigsMaxCount = [Convert]::ToInt32(("1" * $filteredConfigsConfigLength), 2)

  for($i = $filteredConfigsMaxCount; $i -ge 0; $i--) {
    $binaryString = [Convert]::ToString($i, 2).PadLeft($filteredConfigsConfigLength, '0')
    $booleanSplit = $binaryString.ToCharArray() | ForEach-Object { $_ -eq '1' }
    $combination = [ordered]@{}
    foreach($config in $booleanConfigs) {
      $combination[$config] = $true
    }

    for($index = 0; $index -lt $booleanSplit.Count; $index++) {
      $configKey = $filteredConfigs[$index]
      $combination[$configKey] = $booleanSplit[$index]
    }

    $combinations += $combination
  }
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
    if($combination.Contains($line)) {
      $setting = $combination[$line].ToString().ToLower()
      $updatedLine = $line -replace "true", $setting
      $updatedLines += $updatedLine
    }
    if($mode -eq "apply" -and $updatedLine -like "*_resource_group_name*" -and $updatedLine -match "rg-") {
      $updatedLine = $updatedLine -replace "rg-", "rg-${shortName}-"
    }
    if($mode -eq "apply" -and $updatedLine -like "*management_group_name*") {
      $updatedLine = $updatedLine -replace " `"", " `"${shortName}-"
    }
    if($mode -eq "apply" -and $updatedLine -like "*alz = {*") {
      $updatedLine = $updatedLine -replace "alz = {", "${shortName}-alz = {"
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
        OutputLog = "init.log"
      }
    ) `
    -workingDirectory $rootModuleFolderPath `
    -printOutputOnError

  if(-not $success) {
    Write-Host "Failed to initialize Terraform."
    Write-Host "Combination: $combinationNumber of $($combinations.Count)"
    Write-Host "$($updatedLines | ConvertTo-Json -Depth 10)"
    return $false
  }

  if($mode -eq "plan") {
    $success = Invoke-TerraformWithRetry `
      -commands @(@{
        Command = "plan"
        Arguments = @("-out=tfplan")
      }) `
      -workingDirectory $rootModuleFolderPath `
      -printOutputOnError

    if(-not $success) {
      Write-Host "Failed to generate plan."
      Write-Host "Combination: $combinationNumber of $($combinations.Count)"
      Write-Host "$($updatedLines | ConvertTo-Json -Depth 10)"
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
      Write-Host "Combination: $combinationNumber of $($combinations.Count)"
      Write-Host "$($updatedLines | ConvertTo-Json -Depth 10)"
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
          OutputLog = "$logFolder/apply-plan.log"
        },
        @{
          Command = "show"
          Arguments = @("-json", "tfplan")
          OutputLog = "$logFolder/apply-plan.json"
        }
        @{
          Command = "apply"
          Arguments = @("tfplan")
          OutputLog = "$logFolder/apply.log"
        }
      ) `
      -workingDirectory $rootModuleFolderPath

    if(-not $applySuccess) {
      Write-Host "Failed to apply Terraform."
      Write-Host "Combination: $combinationNumber of $($combinations.Count)"
      Write-Host "$($updatedLines | ConvertTo-Json -Depth 10)"
    } else {
      Write-Host "Terraform apply completed successfully for combination $combinationNumber of $($combinations.Count)."
    }

    $destroySuccess = Invoke-TerraformWithRetry `
      -commands @(
        @{
          Command = "plan"
          Arguments = @("-destroy","-out=tfplan")
          OutputLog = "$logFolder/destroy-plan.log"
        },
        @{
          Command = "apply"
          Arguments = @("tfplan")
          OutputLog = "$logFolder/destroy.log"
        }
      ) `
      -workingDirectory $rootModuleFolderPath `
      -retryOn @("*")

    if(-not $destroySuccess) {
      Write-Host "Failed to destroy Terraform resources."
      Write-Host "Combination: $combinationNumber of $($combinations.Count)"
      Write-Host "$($updatedLines | ConvertTo-Json -Depth 10)"
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
