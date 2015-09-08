<#
.SYNOPSIS
  Get the credential stored in the PasswordVault for a given resource.
.PARAMETER Resource
  The resource to fetch from the PasswordVault
.PARAMETER User
  The user connected to the resource
.EXAMPLE
  Get-Credential https://msdn.microsoft.com

  Description
  -----------
  Gets the credemtials for all users stored in the PasswordVault for the resource https://msdn.microsoft.com

.EXAMPLE
  Get-Credential -User john.doe

  Description
  -----------
  Gets the credentials for all the resources from the PasswordVault used by john.doe

.EXAMPLE
  Get-Credential -Resource https://msdn.microsoft.com -User CONTOSO\john.doe

  Description
  -----------
  Gets the credentials for the user john.doe on domain CONTOSO for the resource https://msdn.microsoft.com
#>
function Get-VaultCredential #{{{
{
  [CmdletBinding()]
  [OutputType([System.Management.Automation.PSCredential])]
  Param(
    [Parameter(Position=1, Mandatory=$false, ValueFromPipeLine=$true, ValueFromPipelineByPropertyName = $true)]
    [ValidateNotNullOrEmpty()]
    [string] $Resource,
    [Parameter(Position=2, Mandatory=$false, ValueFromPipelineByPropertyName = $true)]
    [Alias('UserName', 'UserId', 'Name')]
    [string] $User
  )
  process
  {
    try
    {
      $vault = New-Object Windows.Security.Credentials.PasswordVault
      &{
        if (! [string]::IsNullOrEmpty($Resource) -and ! [string]::IsNullOrEmpty($User))
        {
          Write-Verbose "Retrieving Credential for Resource $Resource and user $User"
          $vault.Retrieve($Resource, $User)
        }
        elseif(! [string]::IsNullOrEmpty($Resource))
        {
          Write-Verbose "Retrieving Credential for Resource $Resource"
          $vault.FindAllByResource($Resource)
        }
        elseif(! [string]::IsNullOrEmpty($User))
        {
          Write-Verbose "Retrieving Credential for user $User"
          $vault.FindAllByUserName($User)
        }
        else
        {
          $vault.RetrieveAll()
        }
      } | ForEach {
        Write-Verbose "Found: @{ Resource=`"$($_.Resource)`"; UserName=`"$($_.UserName)`"; Password=`"$($_.Password)`" }"
        $_.RetrievePassword()
        if ([string]::IsNullOrWhiteSpace($_.Password))
        {
          Throw [ArgumentNullException] 'password', 'Password is null or contains white spaces only'
        }
        New-Object System.Management.Automation.PSCredential $_.UserName, (ConvertTo-SecureString $_.Password -AsPlainText -Force) | `
        Add-Member -NotePropertyName 'Resource' -NotePropertyValue $_.Resource -Force -PassThru
      }
    }
    catch
    {
      Throw $_
    }
  }
} # }}}
