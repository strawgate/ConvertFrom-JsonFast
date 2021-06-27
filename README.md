# ConvertFrom-JsonFast
A significantly faster and more memory efficient implementation of ConvertFrom-Json and Invoke-RestMethod

Github: https://github.com/strawgate/ConvertFrom-JsonFast

Powershell Gallery: https://www.powershellgallery.com/packages/ConvertFrom-JsonFast

# Purpose
This module introduces two new functions with partial compability with their namesake functions. These functions consume 1/2 as much memory and have runtime performance 5-6x faster as their namesake functions.

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
