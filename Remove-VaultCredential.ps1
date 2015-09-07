<#
.SYNOPSIS
  Remove the given credential in the PasswordVault for a given resource.
#>
function Remove-VaultCredential #{{{
{
  [CmdletBinding(DefaultParameterSetName='Credential', ConfirmImpact='Medium')]
  Param(
    [Parameter(Position=1, ParameterSetName='Credential', Mandatory=$true, ValueFromPipeLine=$true, ValueFromPipelineByPropertyName = $true)]
    [Parameter(Position=1, ParameterSetName='Plain',     Mandatory=$true, ValueFromPipeLine=$true, ValueFromPipelineByPropertyName = $true)]
    [ValidateNotNullOrEmpty()]
    [string] $Resource,
    [Parameter(Position=2, ParameterSetName='Credential', Mandatory=$true, ValueFromPipelineByPropertyName = $true)]
    [System.Management.Automation.PSCredential] $Credential,
    [Parameter(Position=2, ParameterSetName='Plain',      Mandatory=$true, ValueFromPipelineByPropertyName = $true)]
    [Alias('UserName', 'UserId', 'Name')]
    [string] $User,
    [Parameter(Position=2, ParameterSetName='VaultCredential', Mandatory=$true, ValueFromPipelineByPropertyName = $true)]
    [ValidateNotNullOrEmpty()]
    [Windows.Security.Credentials.PasswordCredential] $VaultCredential
  )
  process
  {
    try
    {
      $vault = New-Object Windows.Security.Credentials.PasswordVault
      switch ($PSCmdlet.ParameterSetName)
      {
        'Plain'
        {
          Write-Verbose "Retrieving Credential for Resource $Resource and user $User"
          $VaultCredential = $vault.Retrieve($Resource, $User)
        }
        'Credential'
        {
          Write-Verbose "Retrieving Credential for Resource $Resource and user $($Credential.UserName)"
          $VaultCredential = $vault.Retrieve($Resource, $Credential.UserName)
        }
      }
      Write-Verbose "Removing Credential for Resource $($VaultCredential.Resource) and user $($VaultCredential.UserName)"
      $vault.Remove($VaultCredential)
    }
    catch
    {
      Throw $_
    }
  }
}
