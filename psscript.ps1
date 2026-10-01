Param (
    [Parameter(Mandatory = $true)] [string] $AzureUserName,
    [string] $AzurePassword,
    [string] $AzureTenantID,
    [string] $AzureSubscriptionID,
    [string] $ODLID,
    [string] $DeploymentID,
    [string] $vmAdminUsername,
    [string] $vmAdminPassword,
    [string] $trainerUserName,
    [string] $trainerUserPassword,
    [string] $AppID,
    [string] $AppSecret,
    [string] $foundryAccountName,
    [string] $aiProjectName,
    [string] $searchServiceName,
    [string] $appInsightsName,
    [string] $logAnalyticsName,
    [string] $storageAccountName,
    [string] $blobContainerName,
    [string] $bingResourceName,
    [string] $FoundryAccountResourceId,
    [string] $FoundryAccountKey1,
    [string] $FoundryAccountEndpoint,
    [string] $FoundryProjectResourceId,
    [string] $SearchServiceResourceId,
    [string] $SearchServiceKey,
    [string] $SearchServiceEndpoint,
    [string] $BingResourceId,
    [string] $BingResourceKey,
    [string] $AppInsightsConnectionString,
    [string] $AzureUserObjectID,
    [string] $searchConnectionName,
    [string] $bingConnectionName,
    [string] $appInsightsConnectionName,
    [string] $SearchConnectionId,
    [string] $BingConnectionId,
    [string] $AppInsightsConnectionId,
    [string] $SearchConnectionTarget,
    [string] $BingConnectionTarget,
    [string] $AppInsightsConnectionTarget
)

Start-Transcript -Path C:\WindowsAzure\Logs\CloudLabsCustomScriptExtension.txt -Append
[Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12

# ---------- Env vars ----------
[System.Environment]::SetEnvironmentVariable('AppID',              $AppID,              [System.EnvironmentVariableTarget]::Machine)
[System.Environment]::SetEnvironmentVariable('AppSecret',          $AppSecret,          [System.EnvironmentVariableTarget]::Machine)
[System.Environment]::SetEnvironmentVariable('DeploymentID',       $DeploymentID,       [System.EnvironmentVariableTarget]::Machine)
[System.Environment]::SetEnvironmentVariable('AzureSubscriptionID',$AzureSubscriptionID,[System.EnvironmentVariableTarget]::Machine)
[System.Environment]::SetEnvironmentVariable('AzureTenantID',      $AzureTenantID,      [System.EnvironmentVariableTarget]::Machine)
[System.Environment]::SetEnvironmentVariable('AzureUserName',      $AzureUserName,      [System.EnvironmentVariableTarget]::Machine)
[System.Environment]::SetEnvironmentVariable('AzurePassword',      $AzurePassword,      [System.EnvironmentVariableTarget]::Machine)
[System.Environment]::SetEnvironmentVariable('foundryAccountName', $foundryAccountName, [System.EnvironmentVariableTarget]::Machine)
[System.Environment]::SetEnvironmentVariable('aiProjectName',      $aiProjectName,      [System.EnvironmentVariableTarget]::Machine)
[System.Environment]::SetEnvironmentVariable('searchServiceName',  $searchServiceName,  [System.EnvironmentVariableTarget]::Machine)
[System.Environment]::SetEnvironmentVariable('appInsightsName',    $appInsightsName,    [System.EnvironmentVariableTarget]::Machine)
[System.Environment]::SetEnvironmentVariable('logAnalyticsName',   $logAnalyticsName,   [System.EnvironmentVariableTarget]::Machine)
[System.Environment]::SetEnvironmentVariable('storageAccountName', $storageAccountName, [System.EnvironmentVariableTarget]::Machine)
[System.Environment]::SetEnvironmentVariable('blobContainerName',  $blobContainerName,  [System.EnvironmentVariableTarget]::Machine)
[System.Environment]::SetEnvironmentVariable('bingResourceName',   $bingResourceName,   [System.EnvironmentVariableTarget]::Machine)
[System.Environment]::SetEnvironmentVariable('FoundryAccountResourceId',   $FoundryAccountResourceId,   [System.EnvironmentVariableTarget]::Machine)
[System.Environment]::SetEnvironmentVariable('FoundryAccountKey1',         $FoundryAccountKey1,         [System.EnvironmentVariableTarget]::Machine)
[System.Environment]::SetEnvironmentVariable('FoundryAccountEndpoint',     $FoundryAccountEndpoint,     [System.EnvironmentVariableTarget]::Machine)
[System.Environment]::SetEnvironmentVariable('FoundryProjectResourceId',   $FoundryProjectResourceId,   [System.EnvironmentVariableTarget]::Machine)
[System.Environment]::SetEnvironmentVariable('SearchServiceResourceId',    $SearchServiceResourceId,    [System.EnvironmentVariableTarget]::Machine)
[System.Environment]::SetEnvironmentVariable('SearchServiceKey',           $SearchServiceKey,           [System.EnvironmentVariableTarget]::Machine)
[System.Environment]::SetEnvironmentVariable('SearchServiceEndpoint',      $SearchServiceEndpoint,      [System.EnvironmentVariableTarget]::Machine)
[System.Environment]::SetEnvironmentVariable('BingResourceId',             $BingResourceId,             [System.EnvironmentVariableTarget]::Machine)
[System.Environment]::SetEnvironmentVariable('BingResourceKey',            $BingResourceKey,            [System.EnvironmentVariableTarget]::Machine)
[System.Environment]::SetEnvironmentVariable('AppInsightsConnectionString',$AppInsightsConnectionString,[System.EnvironmentVariableTarget]::Machine)
[System.Environment]::SetEnvironmentVariable('AzureUserObjectID',          $AzureUserObjectID,          [System.EnvironmentVariableTarget]::Machine)

# Connection-related environment variables
[System.Environment]::SetEnvironmentVariable('searchConnectionName',       $searchConnectionName,       [System.EnvironmentVariableTarget]::Machine)
[System.Environment]::SetEnvironmentVariable('bingConnectionName',         $bingConnectionName,         [System.EnvironmentVariableTarget]::Machine)
[System.Environment]::SetEnvironmentVariable('appInsightsConnectionName',  $appInsightsConnectionName,  [System.EnvironmentVariableTarget]::Machine)
[System.Environment]::SetEnvironmentVariable('SearchConnectionId',         $SearchConnectionId,         [System.EnvironmentVariableTarget]::Machine)
[System.Environment]::SetEnvironmentVariable('BingConnectionId',           $BingConnectionId,           [System.EnvironmentVariableTarget]::Machine)
[System.Environment]::SetEnvironmentVariable('AppInsightsConnectionId',    $AppInsightsConnectionId,    [System.EnvironmentVariableTarget]::Machine)
[System.Environment]::SetEnvironmentVariable('SearchConnectionTarget',     $SearchConnectionTarget,     [System.EnvironmentVariableTarget]::Machine)
[System.Environment]::SetEnvironmentVariable('BingConnectionTarget',       $BingConnectionTarget,       [System.EnvironmentVariableTarget]::Machine)
[System.Environment]::SetEnvironmentVariable('AppInsightsConnectionTarget',$AppInsightsConnectionTarget,[System.EnvironmentVariableTarget]::Machine)

# ---------- CloudLabs common ----------
$path = (Get-Location).Path
$commonscriptpath = "$path\cloudlabs-common\cloudlabs-windows-functions.ps1"
. $commonscriptpath

# Run Imported functions from cloudlabs-windows-functions.ps1
WindowsServerCommon
InstallAzCLI
InstallAzPowerShellModule
InstallChocolatey

CreateCredFile $AzureUserName $AzurePassword $AzureTenantID $AzureSubscriptionID $DeploymentID
Enable-CloudLabsEmbeddedShadow $vmAdminUsername $trainerUserName $trainerUserPassword
choco install git -y
choco install azure-cli -y
choco install azd -y
choco install vscode.install -y
choco install python --version=3.11.0



# logon task
$AppID = $env:AppID
$AppSecret = $env:AppSecret
$DeploymentID = $env:DeploymentID
# Connect to Azure
. C:\LabFiles\AzureCreds.ps1
 
$userName = $env:AzureUserName
$password = $env:AzurePassword
$subscriptionId = $env:AzureSubscriptionID
$TenantID = $env:AzureTenantID
$securePassword = $env:AppSecret | ConvertTo-SecureString -AsPlainText -Force
$cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $AppID, $SecurePassword
# If we are using Connect-AzAccount we need to use Login-AzAccount
Connect-AzAccount -ServicePrincipal -Credential $cred -Tenant $AzureTenantID | Out-Null
$FoundryAccountResourceId = $env:FoundryAccountResourceId
# Assign roles to user on Azure AI Foundry
try {
    $userObjectId = $env:AzureUserObjectID
    $resourceGroupName = (Get-AzResourceGroup | Select-Object -First 1).ResourceGroupName
    
    $roleNames = @(
        'Azure AI Developer', 
        'Foundry User', 
        'Cognitive Services OpenAI User',
        'Foundry Owner',
        'Azure AI Administrator'
    )
    
    # Fetch all role IDs first at Foundry level
    $roleIds = @()
    foreach ($roleName in $roleNames) {
        $roleId = (Get-AzRoleDefinition -Name $roleName -Scope $FoundryAccountResourceId -ErrorAction SilentlyContinue).Id
        if ($roleId) {
            $roleIds += @{ Name = $roleName; Id = $roleId }
        }
    }
    
    # Assign roles to user on Foundry
    foreach ($role in $roleIds) {
        try {
            $roleAssignment = Get-AzRoleAssignment -ObjectId $userObjectId -RoleDefinitionId $role.Id -Scope $FoundryAccountResourceId -ErrorAction SilentlyContinue
            if (-not $roleAssignment) {
                New-AzRoleAssignment -ObjectId $userObjectId -RoleDefinitionId $role.Id -Scope $FoundryAccountResourceId -ErrorAction Stop | Out-Null
                Write-Host "Assigned role '$($role.Name)' to user $AzureUserName"
            } else {
                Write-Host "Role '$($role.Name)' already assigned to user $AzureUserName"
            }
        } catch {
            Write-Host "Error assigning role '$($role.Name)' to user $($AzureUserName): $_"
        }
    }
} catch {
    Write-Host "Error assigning roles: $_"
}

# Enable system assigned identity for AI Search
try {
    $searchServiceName = $env:searchServiceName
    $resourceGroupName = (Get-AzResourceGroup | Select-Object -First 1).ResourceGroupName

    $searchService = Get-AzResource `
        -ResourceType "Microsoft.Search/searchServices" `
        -Name $searchServiceName `
        -ResourceGroupName $resourceGroupName

    if ($searchService) {

        $body = @{
            identity = @{
                type = "SystemAssigned"
            }
        } | ConvertTo-Json -Depth 5

        Invoke-AzRestMethod `
            -Method PATCH `
            -Path "$($searchService.ResourceId)?api-version=2023-11-01" `
            -Payload $body

        Write-Host "System assigned identity enabled for AI Search: $searchServiceName"
    }
    else {
        Write-Host "AI Search service not found: $searchServiceName"
    }
}
catch {
    Write-Host "Error enabling system assigned identity for AI Search: $_"
}

# Set API access control to Both (API keys + RBAC)
try {
    $searchServiceName = $env:searchServiceName
    $resourceGroupName = (Get-AzResourceGroup | Select-Object -First 1).ResourceGroupName

    $searchService = Get-AzResource `
        -ResourceType "Microsoft.Search/searchServices" `
        -Name $searchServiceName `
        -ResourceGroupName $resourceGroupName

    if ($searchService) {
        $body = @{
            properties = @{
                authOptions = @{
                    aadOrApiKey = @{
                        aadAuthFailureMode = "http401WithBearerChallenge"
                    }
                }
            }
        } | ConvertTo-Json -Depth 5

        Invoke-AzRestMethod `
            -Method PATCH `
            -Path "$($searchService.ResourceId)?api-version=2023-11-01" `
            -Payload $body

        Write-Host "API access control set to Both (API Keys + Azure AD) for Search Service: $searchServiceName"
    }
    else {
        Write-Host "Search Service not found: $searchServiceName"
    }
}
catch {
    Write-Host "Error setting API access control for Search Service: $_"
}

# Assign roles to user on Search Service
try {
    $userObjectId = $env:AzureUserObjectID
    $searchServiceName = $env:searchServiceName
    $resourceGroupName = (Get-AzResourceGroup | Select-Object -First 1).ResourceGroupName
    
    $searchService = Get-AzResource -ResourceType "Microsoft.Search/searchServices" -Name $searchServiceName -ResourceGroupName $resourceGroupName
    if ($searchService) {
        $searchServiceResourceId = $searchService.ResourceId
        
        $searchRoleNames = @('Search Index Data Contributor', 'Search Index Data Reader', 'Search Service Contributor')
        
        # Fetch all role IDs at Search Service level
        $searchRoleIds = @()
        foreach ($roleName in $searchRoleNames) {
            $roleId = (Get-AzRoleDefinition -Name $roleName -Scope $searchServiceResourceId -ErrorAction SilentlyContinue).Id
            if ($roleId) {
                $searchRoleIds += @{ Name = $roleName; Id = $roleId }
            }
        }
        
        # Assign roles to user on Search Service
        foreach ($role in $searchRoleIds) {
            try {
                $roleAssignment = Get-AzRoleAssignment -ObjectId $userObjectId -RoleDefinitionId $role.Id -Scope $searchServiceResourceId -ErrorAction SilentlyContinue
                if (-not $roleAssignment) {
                    New-AzRoleAssignment -ObjectId $userObjectId -RoleDefinitionId $role.Id -Scope $searchServiceResourceId -ErrorAction Stop | Out-Null

                    Write-Host "Assigned role '$($role.Name)' to user $AzureUserName on Search Service $searchServiceName"
                } else {
                    Write-Host "Role '$($role.Name)' already assigned to user $AzureUserName on Search Service $searchServiceName"
                }
            } catch {
                Write-Host "Error assigning role '$($role.Name)' to user $AzureUserName on Search Service: $_"
            }
        }
        
        # Assign roles to managed identity on Search Service
        try {
            $searchManagedIdentityObjectId = $searchService.Identity.PrincipalId
            if ($searchManagedIdentityObjectId) {
                foreach ($role in $searchRoleIds) {
                    try {
                        $miRoleAssignment = Get-AzRoleAssignment -ObjectId $searchManagedIdentityObjectId -RoleDefinitionId $role.Id -Scope $searchServiceResourceId -ErrorAction SilentlyContinue
                        if (-not $miRoleAssignment) {
                            New-AzRoleAssignment -ObjectId $searchManagedIdentityObjectId -RoleDefinitionId $role.Id -Scope $searchServiceResourceId -ErrorAction Stop | Out-Null
                            Write-Host "Assigned role '$($role.Name)' to Search Service managed identity on Search Service $searchServiceName"
                        } else {
                            Write-Host "Role '$($role.Name)' already assigned to Search Service managed identity on Search Service $searchServiceName"
                        }
                    } catch {
                        Write-Host "Error assigning role '$($role.Name)' to Search Service managed identity: $_"
                    }
                }
            }
        } catch {
            Write-Host "Error assigning roles to Search Service managed identity on Search Service: $_"
        }
        
        # Assign roles to MSFoundry managed identity on Search Service
        try {
            $foundryAccountResourceId = $env:FoundryAccountResourceId
            $foundryAccount = Get-AzResource -ResourceId $foundryAccountResourceId
            if ($foundryAccount -and $foundryAccount.Identity.PrincipalId) {
                $foundryManagedIdentityObjectId = $foundryAccount.Identity.PrincipalId
                foreach ($role in $searchRoleIds) {
                    try {
                        $foundryRoleAssignment = Get-AzRoleAssignment -ObjectId $foundryManagedIdentityObjectId -RoleDefinitionId $role.Id -Scope $searchServiceResourceId -ErrorAction SilentlyContinue
                        if (-not $foundryRoleAssignment) {
                            New-AzRoleAssignment -ObjectId $foundryManagedIdentityObjectId -RoleDefinitionId $role.Id -Scope $searchServiceResourceId -ErrorAction Stop | Out-Null
                            Write-Host "Assigned role '$($role.Name)' to MSFoundry managed identity on Search Service $searchServiceName"
                        } else {
                            Write-Host "Role '$($role.Name)' already assigned to MSFoundry managed identity on Search Service $searchServiceName"
                        }
                    } catch {
                        Write-Host "Error assigning role '$($role.Name)' to MSFoundry managed identity: $_"
                    }
                }
            }
        } catch {
            Write-Host "Error assigning roles to MSFoundry managed identity on Search Service: $_"
        }
        
        # Assign roles to project managed identity on Search Service
        try {
            $foundryProjectResourceId = $env:FoundryProjectResourceId
            $foundryProject = Get-AzResource -ResourceId $foundryProjectResourceId
            if ($foundryProject -and $foundryProject.Identity.PrincipalId) {
                $foundryProjectManagedIdentityObjectId = $foundryProject.Identity.PrincipalId
                foreach ($role in $searchRoleIds) {
                    try {
                        $projectRoleAssignment = Get-AzRoleAssignment -ObjectId $foundryProjectManagedIdentityObjectId -RoleDefinitionId $role.Id -Scope $searchServiceResourceId -ErrorAction SilentlyContinue
                        if (-not $projectRoleAssignment) {
                            New-AzRoleAssignment -ObjectId $foundryProjectManagedIdentityObjectId -RoleDefinitionId $role.Id -Scope $searchServiceResourceId -ErrorAction Stop | Out-Null
                            Write-Host "Assigned role '$($role.Name)' to project managed identity on Search Service $searchServiceName"
                        } else {
                            Write-Host "Role '$($role.Name)' already assigned to project managed identity on Search Service $searchServiceName"
                        }
                    } catch {
                        Write-Host "Error assigning role '$($role.Name)' to project managed identity: $_"
                    }
                }
            }
        } catch {
            Write-Host "Error assigning roles to project managed identity on Search Service: $_"
        }

    } else {
        Write-Host "Search Service not found: $searchServiceName"
    }
} catch {
    Write-Host "Error assigning roles on Search Service: $_"
}

[System.Environment]::SetEnvironmentVariable('AZURE_RESOURCE_GROUP', $resourceGroupName, [System.EnvironmentVariableTarget]::Machine)
$AzureOpenAIEndpoint = "https://aifoundry-$($env:DeploymentID).openai.azure.com/"
[System.Environment]::SetEnvironmentVariable('AZURE_OPENAI_ENDPOINT', $AzureOpenAIEndpoint, [System.EnvironmentVariableTarget]::Machine)
$AzureProjectEndpoint = "https://aifoundry-$($env:DeploymentID).services.ai.azure.com/api/projects/project-$($env:DeploymentID)"
[System.Environment]::SetEnvironmentVariable('AZURE_PROJECT_ENDPOINT', $AzureProjectEndpoint, [System.EnvironmentVariableTarget]::Machine)
# Set resource group name and environment variable
$resourceGroupName = "ai-foundry-$($env:DeploymentID)"
[System.Environment]::SetEnvironmentVariable('AZURE_RESOURCE_GROUP', $resourceGroupName, [System.EnvironmentVariableTarget]::Machine)

# Create a new WebClient object
$WebClient = New-Object System.Net.WebClient
# Download the file using the WebClient object
$WebClient.DownloadFile("https://raw.githubusercontent.com/monikan-spektra/Building-and-Operationalizing-AI-Agents-with-Microsoft-Foundry-and-Agent-frameworks/refs/heads/main/logontask.ps1", "C:\LabFiles\logontask.ps1")

#Enable Autologon
$AutoLogonRegPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
Set-ItemProperty -Path $AutoLogonRegPath -Name "AutoAdminLogon" -Value "1" -type String 
Set-ItemProperty -Path $AutoLogonRegPath -Name "DefaultUsername" -Value "$($env:ComputerName)\azureuser" -type String  
Set-ItemProperty -Path $AutoLogonRegPath -Name "DefaultPassword" -Value $vmAdminPassword -type String
Set-ItemProperty -Path $AutoLogonRegPath -Name "AutoLogonCount" -Value "1" -type DWord

# Scheduled Task
$Trigger= New-ScheduledTaskTrigger -AtLogOn
$User= "$($env:ComputerName)\azureuser" 
$Action= New-ScheduledTaskAction -Execute "C:\Windows\System32\WindowsPowerShell\v1.0\Powershell.exe" -Argument "-WindowStyle Hidden -executionPolicy Unrestricted -File C:\LabFiles\logontask.ps1"
Register-ScheduledTask -TaskName "Setup" -Trigger $Trigger -User $User -Action $Action -RunLevel Highest -Force
Stop-Transcript
Restart-Computer -Force
