$ArgumentCompleter = @{
  CommandName = @('Get-VaultCredential',
                  'Set-VaultCredential',
                  'Remove-VaultCredential'
                 );
  ParameterName = 'Resource';
  ScriptBlock   = {
    <#
    .SYNOPSIS
    Auto-complete the -Resource parameter value for Vault Powershell Cmdlets.
    #>
    Param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    $vault = New-Object Windows.Security.Credentials.PasswordVault
    return $vault.retrieveAll() | Where Resource -like "$wordToComplete*" | ForEach {
      New-Object -TypeName System.Management.Automation.CompletionResult -ArgumentList @(
        $_.Resource,
        ("{0} ({1})" -f $_.Resource, $_.UserName),
        [System.Management.Automation.CompletionResultType]::ParameterValue,
        ("UserName: {0}" -f $_.UserName)
      )
    }
  }
}
Write-Verbose "Registering Argument Completer for $($ArgumentCompleter.ParameterName)"
Microsoft.Powershell.Core\Register-ArgumentCompleter @ArgumentCompleter

$ArgumentCompleter = @{
  CommandName = @('Get-VaultCredential',
                  'Set-VaultCredential',
                  'Remove-VaultCredential'
                 );
  ParameterName = 'User';
  ScriptBlock   = {
    <#
    .SYNOPSIS
    Auto-complete the -User parameter value for Vault Powershell Cmdlets.
    #>
    Param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    $vault    = New-Object Windows.Security.Credentials.PasswordVault
    $resource = $fakeBoundParameter['Resource']
    if ($resource)
    {
      return $vault.retrieveAll() | Where { $_.Resource -eq $resource -and $_.UserName -like "*$wordToComplete*" } | ForEach {
        New-Object -TypeName System.Management.Automation.CompletionResult -ArgumentList @(
          $_.UserName,
          ("{0} ({1})" -f $_.Resource, $_.UserName),
          [System.Management.Automation.CompletionResultType]::ParameterValue,
          ("UserName: {0}" -f $_.UserName)
        )
      }
    }
    else
    {
      return $vault.retrieveAll() | Where UserName -like "$wordToComplete*" | ForEach {
        New-Object -TypeName System.Management.Automation.CompletionResult -ArgumentList @(
          $_.UserName,
          ("{0} ({1})" -f $_.Resource, $_.UserName),
          [System.Management.Automation.CompletionResultType]::ParameterValue,
          ("UserName: {0}" -f $_.UserName)
        )
      }
    }
  }
}
Write-Verbose "Registering Argument Completer for $($ArgumentCompleter.ParameterName)"
Microsoft.Powershell.Core\Register-ArgumentCompleter @ArgumentCompleter
