Function Get-Oauth2AuthorizationToken {
    [OutputType([securestring])]
    Param (
        [Parameter(Mandatory)][string] $TenantId,
        [Parameter(Mandatory)][string] $ClientId,
        [Parameter(Mandatory)][securestring] $Password
    )
    Process {
        # Create a hashtable for the body to request token
        $Body = @{
            'tenant' = $TenantId
            'client_id' = $ClientId
            'scope' = 'https://graph.microsoft.com/.default'
            'client_secret' = (ConvertFrom-SecureString -SecureString $Password -AsPlainText)
            'grant_type' = 'client_credentials'
        }

        $Params = @{
            'Uri' = "https://login.microsoftonline.com/$TenantId/oauth2/v2.0/token"
            'Method' = 'Post'
            'Body' = $Body
            'ContentType' = 'application/x-www-form-urlencoded'
        }

        $AuthResponse = Invoke-RestMethod @Params

        return (ConvertTo-SecureString -String $AuthResponse.access_token -AsPlainText -Force)
    }
}
