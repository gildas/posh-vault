# Posh-Vault
Powershell module to use Windows 8+ and 2012+ Password Vault

Installation
------------

If you have [PowerShellGet](http://www.powershellgallery.com) installed just run:
```posh
Install-Module Posh-Vault
```

If not, copy the following line and paste it in a Powershell:

```posh
Start-BitsTransfer https://raw.githubusercontent.com/gildas/posh-vault/master/Install.ps1 $env:TEMP ; & $env:TEMP\Install.ps1
```


The following options are accepted:
- -Path  
  Contains the *path* where Posh-VPN will be installed.  
  When this parameter is not present, the module will be installed in WindowsPowerShell\Modules\Posh-VPN under the user's documents.  
  In general, you will not need this parameter as the default folder gets automatically added in the list of folders where Powershell searches for modules and loads them.  
  Default: None
- -Verbose
  Acts verbosely
- -WhatIf
  Shows what would be done 

Note
----

Due to limitations in the PasswordVault API, only the Web Credentials are accessible.

Usage
-----

To set credentials:
```posh
PS> Set-VaultCredential -Resource https://mysite -User gildas -Password 's3cr3t'
```

It is also possible to use a PSCredential object:
```posh
PS> $creds = Get-Credential ACME\gildas
PS> Set-VaultCredential -Resource https://mysite -Credential $creds
```

To get some credentials:
```posh
PS> $creds = Get-VaultCredential -Resource https://mysite -User gildas
```

To get all credentials for a resource:
```posh
PS> Get-VaultCredential -Resource https://mysite | Format-Table -AutoSize
```

To get all credentials for a user:
```posh
PS> Get-VaultCredential -User gildas | Format-Table -AutoSize
```

To remove some credentials:
```posh
PS> Remove-VaultCredential -Resource https://mysite -User gildas
```

or with PSCredential:
```posh
PS> Remove-VaultCredential -Resource https://mysite -Credential $creds
```

To remove all credentials for a resource:
```posh
PS> Remove-VaultCredential -Resource https://mysite
```

To remove all credentials for a user:
```posh
PS> Remove-VaultCredential -User gildas
```

AUTHORS
=======

Gildas Cherruel
