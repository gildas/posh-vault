if (Get-Module Posh-Vault) { return }

#Requires -Version 3.0
if ($PSVersionTable.PSVersion.Major -lt 3)
{
  Throw "Posh-Vault work only on Powershell 3.0 and higher"
}


try
{
  [void][Windows.Security.Credentials.PasswordVault,Windows.Security.Credentials,ContentType=WindowsRuntime]
}
catch
{
  Throw "PasswordVault API is not available, are you running Windows 8 or 2012 at least?"
}

Push-Location $PSScriptRoot
. .\Get-VaultCredential.ps1
. .\Set-VaultCredential.ps1
. .\Remove-VaultCredential.ps1
Pop-Location
