import-module pester
import-module (Join-Path $PSSCriptRoot "ConvertFrom-JsonFast.psm1") -force

Describe "It Properly Deserializes small Json" {
    it "Handles a simple integer case" {

        $String = "{""tom"":5}"
        $result = ConvertFrom-JsonFast -InputObject $String

        $result | Should -beoftype [hashtable]
        $result.keys.count | should -be 1
        $result.ContainsKey("tom") | should -be $true
        $result["tom"] | should -beoftype [int32]
        $result["tom"] | should -be 5

        convertto-json -InputObject $result -compress | should -be $string
    }
    it "Handles a simple large integer case" {

        $String = "{""tom"":500000000000}"
        $result = ConvertFrom-JsonFast -InputObject $String

        $result | Should -beoftype [hashtable]
        $result.keys.count | should -be 1
        $result.ContainsKey("tom") | should -be $true
        $result["tom"] | should -beoftype [int64]
        $result["tom"] | should -be 500000000000

        convertto-json -InputObject $result -compress | should -be $string
    }
    
    it "Handles a simple large double case" {

        $String = "{""tom"":5000.05}"
        $result = ConvertFrom-JsonFast -InputObject $String

        $result | Should -beoftype [hashtable]
        $result.keys.count | should -be 1
        $result.ContainsKey("tom") | should -be $true
        $result["tom"] | should -beoftype [double]
        $result["tom"] | should -be 5000.05

        convertto-json -InputObject $result -compress | should -be $string
    }

    it "Handles a simple string case" {

        $String = "{""tom"":""5""}"
        $result = ConvertFrom-JsonFast -InputObject $String

        $result | Should -beoftype [hashtable]
        $result.keys.count | should -be 1
        $result.ContainsKey("tom") | should -be $true
        $result["tom"] | should -beoftype [string]
        $result["tom"] | should -be "5"

        convertto-json -InputObject $result -compress | should -be $string
    }
    
    it "Handles a simple boolean case" {

        $String = "{""tom"":false}"
        $result = ConvertFrom-JsonFast -InputObject $String

        $result | Should -beoftype [hashtable]
        $result.keys.count | should -be 1
        $result.ContainsKey("tom") | should -be $true
        $result["tom"] | should -beoftype [bool]
        $result["tom"] | should -be $false

        convertto-json -InputObject $result -compress | should -be $string
    }

}