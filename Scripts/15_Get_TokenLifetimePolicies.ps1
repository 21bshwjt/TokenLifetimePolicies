#region Authentication & Authorization
# Get Token
#endregion

#>

#region generic variables
$BaseApi = 'https://graph.microsoft.com'
$ApiVersion = 'v1.0'
$Endpoint = '/policies/tokenLifetimePolicies'


$Uri = "{0}/{1}{2}" -f $BaseApi, $ApiVersion, $Endpoint

$Headers = @{
    'Authorization' = 'Bearer ' + $Token
    'Content-Type'  = 'application/json'
}

$RequestProperties = @{
    Uri     = $Uri
    Method  = 'GET'
    Headers = $Headers
}
#endregion

#region Invoke-WebRequest
$DefaultDomain = Invoke-RestMethod @RequestProperties
$DefaultDomain.value 

#$DefaultDomain = $DefaultDomain.value | Where-Object isDefault -EQ $true
