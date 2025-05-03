# Entra ID Token Lifetime Policies
- Access Tokens are short-lived credentials issued by Microsoft Entra ID to authorize access to protected resources such as Microsoft Graph, APIs, or web applications. These tokens are bearer tokens and contain claims about the authenticated app, including scopes and expiration.

### OAuth 2.0 Authorization Request URL — specifically for the Implicit Grant Flow
https://login.microsoftonline.com/<Your_Tenant_ID>/oauth2/v2.0/authorize?client_id=<Your_Client_ID>&response_type=token&redirect_uri=https://jwt.ms&scope=https%3A%2F%2Fgraph.microsoft.com%2F.default&state=12345

### OIDC metadata endpoint
https://login.microsoftonline.com/<Your_Tenant_ID>/.well-known/openid-configuration


