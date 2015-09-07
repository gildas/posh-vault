<#
.SYNOPSIS
  Store the given credential in the PasswordVault for a given resource.
#>
function Set-VaultCredential #{{{
{
  [CmdletBinding(DefaultParameterSetName='Credential')]
  Param(
    [Parameter(Position=1, Mandatory=$true, ValueFromPipeLine=$true, ValueFromPipelineByPropertyName = $true)]
    [ValidateNotNullOrEmpty()]
    [string[]] $Resource,
    [Parameter(Position=2, ParameterSetName='Credential', Mandatory=$true, ValueFromPipelineByPropertyName = $true)]
    [System.Management.Automation.PSCredential] $Credential,
    [Parameter(Position=2, ParameterSetName='Plain', Mandatory=$true, ValueFromPipelineByPropertyName = $true)]
    [ValidateNotNullOrEmpty()]
    [Alias('UserName', 'UserId', 'Name')]
    [string] $User,
    [Parameter(Position=3, ParameterSetName='Plain', Mandatory=$true, ValueFromPipelineByPropertyName = $true)]
    [ValidateNotNullOrEmpty()]
    [string] $Password
  )
  process
  {
    $vault = New-Object Windows.Security.Credentials.PasswordVault
    $Resource | ForEach {
      if ($PSCmdlet.ParameterSetName -eq 'Credential')
      {
        $vault_credential = New-Object Windows.Security.Credentials.PasswordCredential $_,$Credential.UserName,$Credential.GetNetworkCredential().Password
      }
      else
      {
        $vault_credential = New-Object Windows.Security.Credentials.PasswordCredential $_,$User,$Password
      }
      $vault.Add($vault_credential)
    }
  }
} # }}}
