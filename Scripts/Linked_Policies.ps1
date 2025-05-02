# === Input Variables ===
$tenantId     = "your-tenant-id"
$clientId     = "your-client-id"
$clientSecret = "your-client-secret"
$appName = "magic portal"

$scope = "https://graph.microsoft.com/.default"
$tokenUrl = "https://login.microsoftonline.com/$tenantId/oauth2/v2.0/token"

# === Get Access Token ===
$tokenBody = @{
    client_id     = $clientId
    scope         = $scope
    client_secret = $clientSecret
    grant_type    = "client_credentials"
}
$response = Invoke-RestMethod -Method POST -Uri $tokenUrl -Body $tokenBody
$accessToken = $response.access_token

$headers = @{
    Authorization  = "Bearer $accessToken"
    "Content-Type" = "application/json"
}

# === Get Application by Name ===
$appUri = "https://graph.microsoft.com/v1.0/applications"
$appList = Invoke-RestMethod -Uri $appUri -Headers $headers -Method GET
$targetApp = $appList.value | Where-Object { $_.displayName -eq $appName }

if (-not $targetApp) {
    Write-Error "❌ Application '$appName' not found."
    return
}

$appId = $targetApp.id

# === Get Assigned Policies ===
$policyUri = "https://graph.microsoft.com/v1.0/applications/$appId/tokenLifetimePolicies"
$policies = Invoke-RestMethod -Uri $policyUri -Headers $headers -Method GET

# === Output Policy Info ===
if ($policies.value.Count -eq 0) {
    Write-Host "ℹ️ No token lifetime policy assigned to app '$appName'."
}
else {
    $report = $policies.value | ForEach-Object {
        $accessTokenLifetime = $null
    
        if ($_.definition -and $_.definition.Count -gt 0) {
            try {
                $parsedDef = ($_.definition[0] | ConvertFrom-Json)
                $accessTokenLifetime = $parsedDef.TokenLifetimePolicy.AccessTokenLifetime
            } catch {
                $accessTokenLifetime = "Error parsing"
            }
        }
    
        [PSCustomObject]@{
            AppName             = $appName
            PolicyId            = $_.id
            DisplayName         = $_.displayName
            IsOrgDefault        = $_.isOrganizationDefault
            AccessTokenLifetime = $accessTokenLifetime
            RawDefinition       = $_.definition
        }
    }
    
    $report | Format-Table -AutoSize
    
}
