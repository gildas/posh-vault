function ResourceCompletion
{
    Param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    $vault = New-Object Windows.Security.Credentials.PasswordVault
    $vault.retrieveAll() | Where Resource -like "$wordToComplete*" | ForEach {
      New-CompletionResult -CompletionText $_.Resource -ToolTip "UserName: $($_.UserName)"
    }
}

function UserCompletion
{
    Param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    $vault    = New-Object Windows.Security.Credentials.PasswordVault
    $resource = $fakeBoundParameter['Resource']
    if ($resource)
    {
      $vault.retrieveAll() | Where { $_.Resource -eq $resource -and $_.UserName -like "*$wordToComplete*" } | ForEach {
        New-CompletionResult -CompletionText $_.UserName
      }
    }
    else
    {
      $vault.retrieveAll() | Where UserName -like "$wordToComplete*" | ForEach {
        New-CompletionResult -CompletionText $_.UserName
      }
    }
}

if (Get-Command Register-ArgumentCompleter -ErrorAction Ignore)
{
  Register-ArgumentCompleter -Command Get-VaultCredential    -Parameter Resource -ScriptBlock $function:ResourceCompletion
  Register-ArgumentCompleter -Command Get-VaultCredential    -Parameter User     -ScriptBlock $function:UserCompletion
  Register-ArgumentCompleter -Command Set-VaultCredential    -Parameter Resource -ScriptBlock $function:ResourceCompletion
  Register-ArgumentCompleter -Command Set-VaultCredential    -Parameter User     -ScriptBlock $function:UserCompletion
  Register-ArgumentCompleter -Command Remove-VaultCredential -Parameter Resource -ScriptBlock $function:ResourceCompletion
  Register-ArgumentCompleter -Command Remove-VaultCredential -Parameter User     -ScriptBlock $function:UserCompletion
}
