Start-Transcript -Path C:\WindowsAzure\Logs\logon.txt -Append

$labRoot      = "C:\LabFiles"
$marker       = Join-Path $labRoot ".setup-complete"
$zipUrl       = "https://experienceazure.blob.core.windows.net/templates/microsoft-foundry-agents-frameworks-workshop/data-ai-immersion-day-nyc-code-main.zip"
$zipPath      = Join-Path $labRoot "data-ai-immersion-day-nyc-code-main.zip"
$sourceFolder = Join-Path $labRoot "data-ai-immersion-day-nyc-code-main"
$targetFolder = Join-Path $labRoot "agentic-ai-immersion-day"
$envFilePath  = Join-Path $targetFolder ".env"

try {
    # ---------- Run only once ----------
    if (Test-Path $marker) {
        Write-Host "Setup already completed earlier. Nothing to do."
        return   # 'finally' below still runs and removes the task
    }

    # ---------- Install VS Code Extensions ----------
    Write-Host "Installing VS Code extensions..."
    # GitHub.copilot removed: Copilot Chat is now built into VS Code, and installing
    # the old extension tries to downgrade it (the harmless error seen in the log).
    code --install-extension ms-python.python 2>&1 | Out-Host
    code --install-extension ms-toolsai.jupyter 2>&1 | Out-Host

    # ---------- Download lab files ----------
    Write-Host "Downloading lab files from storage account..."
    if (-not (Test-Path $labRoot)) { New-Item -ItemType Directory -Path $labRoot -Force | Out-Null }

    # Release anything that may lock the lab folder (VS Code, Pylance, Python)
    Get-Process -Name Code, python, pythonw -ErrorAction SilentlyContinue | Stop-Process -Force
    Start-Sleep -Seconds 3

    # rmdir handles deep .venv trees more reliably than Remove-Item in PowerShell 5.1
    foreach ($folder in @($targetFolder, $sourceFolder)) {
        if (Test-Path $folder) { cmd /c rmdir /s /q "`"$folder`"" }
    }
    if (Test-Path $zipPath) { Remove-Item -Force $zipPath }

    if (Test-Path $targetFolder) {
        throw "Could not delete $targetFolder - another process still has it open."
    }

    Invoke-WebRequest -Uri $zipUrl -OutFile $zipPath -UseBasicParsing
    Expand-Archive -Path $zipPath -DestinationPath $labRoot -Force

    if (-not (Test-Path $sourceFolder)) { throw "Extracted folder not found: $sourceFolder" }
    Rename-Item -Path $sourceFolder -NewName (Split-Path $targetFolder -Leaf)

    # ---------- Update .env (no 'return' here, so the script keeps going) ----------
    Write-Host "Updating .env file with environment variables..."
    if (Test-Path $envFilePath) {
        $map = @{
            "TENANT_ID"                           = $env:AzureTenantID
            "AZURE_SUBSCRIPTION_ID"               = $env:AzureSubscriptionID
            "AZURE_RESOURCE_GROUP"                = $env:AZURE_RESOURCE_GROUP
            "AZURE_PROJECT_NAME"                  = $env:aiProjectName
            "AI_FOUNDRY_PROJECT_ENDPOINT"         = $env:AZURE_PROJECT_ENDPOINT
            "PROJECT_RESOURCE_ID"                 = $env:FoundryProjectResourceId
            "AZURE_OPENAI_ENDPOINT"               = $env:AZURE_OPENAI_ENDPOINT
            "AZURE_OPENAI_API_KEY"                = $env:FoundryAccountKey1
            "AZURE_AI_SEARCH_ENDPOINT"            = $env:SearchServiceEndpoint
            "AZURE_AI_SEARCH_API_KEY"             = $env:SearchServiceKey
            "GROUNDING_WITH_BING_CONNECTION_NAME" = $env:bingResourceName
            "BING_CONNECTION_ID"                  = $env:BingResourceId
            "BING_RESOURCE_KEY"                   = $env:BingResourceKey
        }

        $updated = Get-Content -Path $envFilePath | ForEach-Object {
            $line = $_
            foreach ($key in $map.Keys) {
                if ($line -match "^\s*${key}\s*=") {
                    $val = $map[$key]
                    if ($null -ne $val -and $val -ne "") { $line = "$key=$val" }
                    else { Write-Host "  WARNING: no value for $key" -ForegroundColor Yellow }
                    break
                }
            }
            $line
        }
        Set-Content -Path $envFilePath -Value $updated -Force
        Write-Host ".env file updated at: $envFilePath" -ForegroundColor Green
    }
    else {
        Write-Host ".env not found in the lab files. Skipping .env update." -ForegroundColor Yellow
    }

    # ---------- Python environment ----------
    Write-Host "Creating virtual environment and installing requirements..."
    Set-Location $targetFolder
    python -m venv .venv 2>&1 | Out-Host
    if ($LASTEXITCODE -ne 0) { throw "python -m venv failed (exit $LASTEXITCODE)" }

    $venvPython = Join-Path $targetFolder ".venv\Scripts\python.exe"
    & $venvPython -m pip install --upgrade pip 2>&1 | Out-Host
    & $venvPython -m pip install -r requirements.txt 2>&1 | Out-Host
    if ($LASTEXITCODE -ne 0) { throw "pip install failed (exit $LASTEXITCODE)" }

    New-Item -ItemType File -Path $marker -Force | Out-Null
    Write-Host "Setup completed successfully." -ForegroundColor Green
}
catch {
    Write-Host "SETUP FAILED: $_" -ForegroundColor Red
}
finally {
    # Always remove the task so a failed or partial run can't repeat and wipe the folder
    Write-Host "Removing scheduled task..."
    Unregister-ScheduledTask -TaskName "Setup" -Confirm:$false -ErrorAction SilentlyContinue
    Stop-Transcript
}
