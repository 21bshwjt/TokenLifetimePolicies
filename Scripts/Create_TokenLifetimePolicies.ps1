# Policy.ReadWrite.ApplicationConfiguration
#region Authentication & Authorization
# Get Token
#endregion

# Define token lifetime policy payload
$policyBody = @{
    definition = @(
        '{"TokenLifetimePolicy":{"Version":1,"AccessTokenLifetime":"03:00:00"}}'
    )
    displayName = "AccessTokenPolicy3Hour"
    isOrganizationDefault = $false
} | ConvertTo-Json -Depth 3

# Create the policy
$headers = @{
    Authorization = "Bearer $Token"
    "Content-Type" = "application/json"
}

$uri = "https://graph.microsoft.com/v1.0/policies/tokenLifetimePolicies"

$result = Invoke-RestMethod -Method Post -Uri $uri -Headers $headers -Body $policyBody
$result
