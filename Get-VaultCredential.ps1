<#
.SYNOPSIS
  Get the credential stored in the PasswordVault for a given resource.
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
        Write-Verbose "Found:   @{ Resource=`"$($_.Resource)`"; UserName=`"$($_.UserName)`"; Password=`"$($_.Password)`" }"
        $_.RetrievePassword()
        Write-Verbose "Decoded: @{ Resource=`"$($_.Resource)`"; UserName=`"$($_.UserName)`"; Password=`"$($_.Password)`" }"
        New-Object System.Management.Automation.PSCredential $_.UserName, (ConvertTo-SecureString $_.Password.Trim() -AsPlainText -Force) | `
        Add-Member -NotePropertyName 'Resource' -NotePropertyValue $_.Resource -Force -PassThru
      }
    }
    catch
    {
      Throw $_
    }
  }
} # }}}
