# === Input: Tenant/Auth Info ===
$tenantId     = "your-tenant-id"
$clientId     = "your-client-id"
$clientSecret = "your-client-secret"
$scope        = "https://graph.microsoft.com/.default"
$tokenUrl     = "https://login.microsoftonline.com/$tenantId/oauth2/v2.0/token"

# === Input: Target App & Policy Info ===
$appName   = "Lokka"             # Example: "MyApp"
$policyId  = "e4f06adc-621e-43bf-85bd-296e9be86566"                   # From earlier creation

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
    Authorization = "Bearer $accessToken"
    "Content-Type" = "application/json"
}

# === Get App by Display Name ===
$appUri = "https://graph.microsoft.com/v1.0/applications"
$appList = Invoke-RestMethod -Uri $appUri -Headers $headers -Method GET
$targetApp = $appList.value | Where-Object { $_.displayName -eq $appName }

if (-not $targetApp) {
    Write-Error "❌ App '$appName' not found."
    return
}

# === Assign Policy to App ===
$appId = $targetApp.id
$assignUri = "https://graph.microsoft.com/v1.0/applications/$appId/tokenLifetimePolicies/`$ref"
$assignBody = @{
    "@odata.id" = "https://graph.microsoft.com/v1.0/policies/tokenLifetimePolicies/$policyId"
} | ConvertTo-Json

Invoke-RestMethod -Uri $assignUri -Method POST -Headers $headers -Body $assignBody
Write-Host "✅ Policy assigned to app '$appName' successfully."
