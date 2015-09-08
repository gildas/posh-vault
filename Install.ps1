[CmdletBinding()]
Param(
  [Parameter(Position=1, Mandatory=$false)]
  $Path
)

$ModuleName    = 'Posh-Vault'
$ModuleVersion = '0.1.0'
$GithubRoot    = "https://raw.githubusercontent.com/gildas/posh-vault/$ModuleVersion"

if ([string]::IsNullOrEmpty($Path))
{
  $my_modules   = Join-Path ([Environment]::GetFolderPath('MyDocuments')) 'WindowsPowerShell\Modules'
  $module_paths = @($env:PSModulePath -split ';')

  if (! (Test-Path $my_modules))
  {
    Write-Verbose "Creating Personal Powershell Module folder"
    New-Item -ItemType Directory -Path $my_modules -ErrorAction Stop | Out-Null
  }

  if ($module_paths -notcontains $my_modules)
  {
    Write-Verbose "Adding Personal Powershell Module folder to Module Search list"
    $env:PSModulePath = $my_modules + ';' + $env:PSModulePath
    [Environment]::SetEnvironmentVariable('PSModulePath', $env:PSModulePath, 'User')
  }
  $Path = Join-Path $my_modules $ModuleName
}

if (! (Test-Path $Path))
{
  Write-Verbose "Creating $ModuleName Module folder"
  New-Item -ItemType Directory -Path $Path -ErrorAction Stop | Out-Null
}

@(
  'Get-VaultCredential.ps1',
  'Set-VaultCredential.ps1',
  'Remove-VaultCredential.ps1',
  'LICENSE',
  'VERSION',
  'README.md',
  'Posh-Vault.psd1',
  'Posh-Vault.psm1'
) | ForEach-Object {
  Start-BitsTransfer -DisplayName "$ModuleName Installation" -Description "Installing $_" -Source "$GithubRoot/$_" -Destination $Path -ErrorAction Stop
}
