# Posh-Vaul
Powershell module to use Windows 8+ and 2012+ Password Vault

Installation
------------

If you have [PsGet](http://psget.net) installed just run:
```posh
Install-Module https://github.com/gildas/posh-vault/releases/download/0.1.0/posh-vault-0.1.0.zip
```

Copy the following line and paste it in a Powershell:

```posh
Start-BitsTransfer http://tinyurl.com/posh-vault-0-1-0 $env:TEMP ; & $env:TEMP\Install.ps1
```

To install the latest development version, use one of the followings:

```posh
Install-Module -ModuleUrl https://github.com/gildas/posh-vault/archive/dev.zip
```

```posh
Start-BitsTransfer http://tinyurl.com/posh-vault-dev $env:TEMP ; & $env:TEMP\Install.ps1
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

Due to limitations in the PasswordVault API, only te Web Credentials are accessible.

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
[![endorse](https://api.coderwall.com/gildas/endorsecount.png)](https://coderwall.com/gildas)
