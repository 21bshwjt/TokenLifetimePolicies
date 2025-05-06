# Entra ID Token Lifetime Policies
- Access Tokens are short-lived credentials issued by Microsoft Entra ID to authorize access to protected resources such as Microsoft Graph, APIs, or web applications. These tokens are bearer tokens and contain claims about the authenticated app, including scopes and expiration.

### OAuth 2.0 Authorization Request URL — specifically for the Implicit Grant Flow
https://login.microsoftonline.com/<Your_Tenant_ID>/oauth2/v2.0/authorize?client_id=<Your_Client_ID>&response_type=token&redirect_uri=https://jwt.ms&scope=https%3A%2F%2Fgraph.microsoft.com%2F.default&state=12345

### OIDC Implicit Flow Authorization URL
https://login.microsoftonline.com/<Tenant_ID>/oauth2/v2.0/authorize?client_id=<Client_ID>&response_type=id_token&redirect_uri=https%3A%2F%2Fjwt.ms&scope=openid%20profile&state=123456&nonce=12938&response_mode=fragment

### OpenID Connect Authorization Endpoint URL
https://login.microsoftonline.com/aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee/oauth2/v2.0/authorize?
client_id=11111111-2222-3333-4444-555555555555
&response_type=code
&redirect_uri=http://localhost:3000/callback
&response_mode=query
&scope=openid profile email
&state=abc123


### OIDC metadata endpoint
https://login.microsoftonline.com/<Your_Tenant_ID>/.well-known/openid-configuration

### Pode 
```powershell
# Install the Pode module if you haven't
# Install-Module -Name Pode -Scope CurrentUser -Force

Import-Module Pode

Start-PodeServer {
    Add-PodeEndpoint -Address * -Port 3000 -Protocol Http

    Add-PodeRoute -Method Get -Path "/callback" -ScriptBlock {
        $code = $WebEvent.Query['code']
        $state = $WebEvent.Query['state']

        Write-Host "Received callback with code: $code"
        Write-Host "State: $state"

        Write-PodeTextResponse -Value "OAuth callback received. Congrats for testing with Pode!"
    }
}
```


