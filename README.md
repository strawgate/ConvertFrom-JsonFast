# ConvertFrom-JsonFast
A significantly faster and more memory efficient implementation of ConvertFrom-Json and Invoke-RestMethod. Supports most commonly used flags and pipeline usage.

Github: https://github.com/strawgate/ConvertFrom-JsonFast

Powershell Gallery: https://www.powershellgallery.com/packages/ConvertFrom-JsonFast

# Purpose
This module introduces two new functions with partial compability with their namesake functions. These functions consume 1/2 as much memory and have runtime performance 5-6x faster as their namesake functions.

# Compatibility
This module currently achieves 216/224 tests when the ConvertFrom-Json tests are run against it. The 8 failing tests are:

```
    [-] Fails to convert an object of depth higher than 1024 by default with AsHashtable switch set to $true 42ms
      Expected an exception, with FullyQualifiedErrorId 'System.ArgumentException,Microsoft.PowerShell.Commands.ConvertFromJsonCommand' to be thrown, but the FullyQualifiedErrorId was 'JsonReaderException,ConvertFrom-JsonFast'. from C:\Users\weaston-ou\Documents\ConvertFrom-JsonFast\ConvertFrom-JsonFast.ms.tests.ps1:111 char:25
          + …    { $nestedJson | ConvertFrom-JsonFast -AsHashtable:$AsHashtable } |
          +                      ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      112:             Should -Throw -ErrorId "System.ArgumentException,Microsoft.PowerShell.Commands.ConvertFromJsonCommand"
      at <ScriptBlock>, C:\Users\weaston-ou\Documents\ConvertFrom-JsonFast\ConvertFrom-JsonFast.ms.tests.ps1: line 111
    [-] Fails to convert an object of depth higher than 1024 by default with AsHashtable switch set to $false 45ms
      Expected an exception, with FullyQualifiedErrorId 'System.ArgumentException,Microsoft.PowerShell.Commands.ConvertFromJsonCommand' to be thrown, but the FullyQualifiedErrorId was 'JsonReaderException,ConvertFrom-JsonFast'. from C:\Users\weaston-ou\Documents\ConvertFrom-JsonFast\ConvertFrom-JsonFast.ms.tests.ps1:111 char:25
          + …    { $nestedJson | ConvertFrom-JsonFast -AsHashtable:$AsHashtable } |
          +                      ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      112:             Should -Throw -ErrorId "System.ArgumentException,Microsoft.PowerShell.Commands.ConvertFromJsonCommand"
      at <ScriptBlock>, C:\Users\weaston-ou\Documents\ConvertFrom-JsonFast\ConvertFrom-JsonFast.ms.tests.ps1: line 111
    [-] Fails to convert an object with greater depth than Depth param set to 2 and AsHashtable switch set to $true 7ms
      Expected an exception, with FullyQualifiedErrorId 'System.ArgumentException,Microsoft.PowerShell.Commands.ConvertFromJsonCommand' to be thrown, but the FullyQualifiedErrorId was 'JsonReaderException,ConvertFrom-JsonFast'. from C:\Users\weaston-ou\Documents\ConvertFrom-JsonFast\ConvertFrom-JsonFast.ms.tests.ps1:201 char:25
          + … estedJson | ConvertFrom-JsonFast -AsHashtable:$AsHashtable -Depth $De …
          +               ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      202:             Should -Throw -ErrorId "System.ArgumentException,Microsoft.PowerShell.Commands.ConvertFromJsonCommand"
      at <ScriptBlock>, C:\Users\weaston-ou\Documents\ConvertFrom-JsonFast\ConvertFrom-JsonFast.ms.tests.ps1: line 201
    [-] Fails to convert an object with greater depth than Depth param set to 2 and AsHashtable switch set to $false 9ms
      Expected an exception, with FullyQualifiedErrorId 'System.ArgumentException,Microsoft.PowerShell.Commands.ConvertFromJsonCommand' to be thrown, but the FullyQualifiedErrorId was 'JsonReaderException,ConvertFrom-JsonFast'. from C:\Users\weaston-ou\Documents\ConvertFrom-JsonFast\ConvertFrom-JsonFast.ms.tests.ps1:201 char:25
          + … estedJson | ConvertFrom-JsonFast -AsHashtable:$AsHashtable -Depth $De …
          +               ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      202:             Should -Throw -ErrorId "System.ArgumentException,Microsoft.PowerShell.Commands.ConvertFromJsonCommand"
      at <ScriptBlock>, C:\Users\weaston-ou\Documents\ConvertFrom-JsonFast\ConvertFrom-JsonFast.ms.tests.ps1: line 201
    [-] Fails to convert an object with greater depth than Depth param set to 200 and AsHashtable switch set to $true 9ms
      Expected an exception, with FullyQualifiedErrorId 'System.ArgumentException,Microsoft.PowerShell.Commands.ConvertFromJsonCommand' to be thrown, but the FullyQualifiedErrorId was 'JsonReaderException,ConvertFrom-JsonFast'. from C:\Users\weaston-ou\Documents\ConvertFrom-JsonFast\ConvertFrom-JsonFast.ms.tests.ps1:201 char:25
          + … estedJson | ConvertFrom-JsonFast -AsHashtable:$AsHashtable -Depth $De …
          +               ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      202:             Should -Throw -ErrorId "System.ArgumentException,Microsoft.PowerShell.Commands.ConvertFromJsonCommand"
      at <ScriptBlock>, C:\Users\weaston-ou\Documents\ConvertFrom-JsonFast\ConvertFrom-JsonFast.ms.tests.ps1: line 201
    [-] Fails to convert an object with greater depth than Depth param set to 200 and AsHashtable switch set to $false 4ms
      Expected an exception, with FullyQualifiedErrorId 'System.ArgumentException,Microsoft.PowerShell.Commands.ConvertFromJsonCommand' to be thrown, but the FullyQualifiedErrorId was 'JsonReaderException,ConvertFrom-JsonFast'. from C:\Users\weaston-ou\Documents\ConvertFrom-JsonFast\ConvertFrom-JsonFast.ms.tests.ps1:201 char:25
          + … estedJson | ConvertFrom-JsonFast -AsHashtable:$AsHashtable -Depth $De …
          +               ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      202:             Should -Throw -ErrorId "System.ArgumentException,Microsoft.PowerShell.Commands.ConvertFromJsonCommand"
      at <ScriptBlock>, C:\Users\weaston-ou\Documents\ConvertFrom-JsonFast\ConvertFrom-JsonFast.ms.tests.ps1: line 201
    [-] Fails to convert an object with greater depth than Depth param set to 2000 and AsHashtable switch set to $true 25ms
      Expected an exception, with FullyQualifiedErrorId 'System.ArgumentException,Microsoft.PowerShell.Commands.ConvertFromJsonCommand' to be thrown, but the FullyQualifiedErrorId was 'JsonReaderException,ConvertFrom-JsonFast'. from C:\Users\weaston-ou\Documents\ConvertFrom-JsonFast\ConvertFrom-JsonFast.ms.tests.ps1:201 char:25
          + … estedJson | ConvertFrom-JsonFast -AsHashtable:$AsHashtable -Depth $De …
          +               ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      202:             Should -Throw -ErrorId "System.ArgumentException,Microsoft.PowerShell.Commands.ConvertFromJsonCommand"
      at <ScriptBlock>, C:\Users\weaston-ou\Documents\ConvertFrom-JsonFast\ConvertFrom-JsonFast.ms.tests.ps1: line 201
    [-] Fails to convert an object with greater depth than Depth param set to 2000 and AsHashtable switch set to $false 26ms
      Expected an exception, with FullyQualifiedErrorId 'System.ArgumentException,Microsoft.PowerShell.Commands.ConvertFromJsonCommand' to be thrown, but the FullyQualifiedErrorId was 'JsonReaderException,ConvertFrom-JsonFast'. from C:\Users\weaston-ou\Documents\ConvertFrom-JsonFast\ConvertFrom-JsonFast.ms.tests.ps1:201 char:25
          + … estedJson | ConvertFrom-JsonFast -AsHashtable:$AsHashtable -Depth $De …
          +               ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      202:             Should -Throw -ErrorId "System.ArgumentException,Microsoft.PowerShell.Commands.ConvertFromJsonCommand"
      at <ScriptBlock>, C:\Users\weaston-ou\Documents\ConvertFrom-JsonFast\ConvertFrom-JsonFast.ms.tests.ps1: line 201
```

If your code relies on the exact exception being thrown from convertfrom-json then this will cause issues for you. As that's an unusual thing to do, this module should be highly compatible.

# Disadvantages
This module does not fully implement invoke-restmethod, it simply calls invoke-webrequest and casts the response using the convertfrom-jsonfast cmdlet.
This module has different handling of special formats like dates
This module may have different number handling (int32 vs int64 vs double vs float) than the original module
This module always returns hashtables and has no option to create pscustomobjects.

# Usage
Simply swap your ConvertFrom-Json functions with ConvertFrom-JsonFast and Invoke-RestMethod with Invoke-RestMethodFast.

# Benchmarks

1 MB JSON File
```
ConvertFrom-JsonFast:           1 MB used over 32 Milliseconds
ConvertFrom-Json -AsHashtable: 16 MB used over 50 Milliseconds
ConvertFrom-Json:              15 MB used over 60 Milliseconds
```

10 MB JSON File
```
ConvertFrom-JsonFast:           56 MB used over 150 Milliseconds
ConvertFrom-Json -AsHashtable: 178 MB used over 766 Milliseconds
ConvertFrom-Json:              120 MB used over 988 Milliseconds
```

100 MB JSON File
```
ConvertFrom-JsonFast:           544 MB used over 1400 Milliseconds
ConvertFrom-Json -AsHashtable: 1077 MB used over 7126 Milliseconds
ConvertFrom-Json:              1330 MB used over 9429 Milliseconds
```

1000 MB JSON File
```
ConvertFrom-JsonFast:           5950 MB used over 16400 Milliseconds
ConvertFrom-Json -AsHashtable: 11106 MB used over 69863 Milliseconds
ConvertFrom-Json:              13575 MB used over 111309 Milliseconds
```
