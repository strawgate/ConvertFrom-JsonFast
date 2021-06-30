Add-Type -TypeDefinition @"
using System;
using System.IO;
using System.Linq;
using System.Collections;
using System.Text.Json;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

public static class JsonHelper
{
    public static object Deserialize(string json, Int32 depth)
    {
        JsonDocumentOptions options = new JsonDocumentOptions();

        options.MaxDepth = depth;

        JsonDocument thisDocument = JsonDocument.Parse(json, options);

        return ToObject(thisDocument.RootElement);
    }

    public static object ToObject(JsonElement element)
    {
        JsonValueKind thisKind = element.ValueKind;

        switch (element.ValueKind) {
            case JsonValueKind.Object:
                var Properties = element.EnumerateObject();

                return new Hashtable(Properties.ToDictionary(prop => prop.Name,
                    prop => ToObject(prop.Value)
                ));
            case JsonValueKind.Array:
                var Entries = element.EnumerateArray();

                return Entries.Select(ToObject).ToArray();

            case JsonValueKind.True:
                return true;
            case JsonValueKind.False:
                return false;
            case JsonValueKind.String:
                return element.GetString();
            case JsonValueKind.Number:
                if (element.TryGetInt32(out _)) { return element.GetInt32(); }
                if (element.TryGetInt64(out _)) { return element.GetInt64(); }
                return element.GetDouble();
            default:
                return null;
        }
    }
}
"@ -ReferencedAssemblies netstandard,System.Collections,System.Linq,System,System.IO,System.Text.Json,Newtonsoft.Json,System.Memory

Function ConvertFrom-JsonFast {
    <#
    .SYNOPSIS
    Converts a json string to a real object
    
    .DESCRIPTION
    Converts a json string to a real object
    
    .PARAMETER InputObject
    The string of json to convert
    
    .EXAMPLE
    ConvertFrom-JsonFast -InputObject "{""Tom"": 5}"
    
    .NOTES
    Objects will be returned as Hashtables and not as pscustomobjects
    #>
	param (
        [Parameter(ValuefromPipeline=$True)]
		$InputObject,
        [int] $Depth = 1024,
        [switch] $AsHashtable,
        [switch] $NoEnumerate
	)
	begin {
        $ObjectBuffer = [System.Collections.ArrayList]::new()
    }

    process {
    	[void] $ObjectBuffer.Add($InputObject)
    }

    end {

		# If our buffer only has one element in it we use this fast path. Otherwise the try{} catch{} block later will cause us to deserialize the object twice.
		if ($ObjectBuffer.count -eq 1) {
			$result = [JsonHelper]::Deserialize($ObjectBuffer[0], $depth)
		}
		
		# We want to support a user passing us two discrete json objects via the pipeline where we deserialize both. So we attempt to
		# deserialize the first object and if it works we then deserialize each object as if it is its own json object.
		else {	
			try {
				[void] ([JsonHelper]::Deserialize($ObjectBuffer[0], $depth))

				$Result = @(foreach ($item in $ObjectBuffer) {
					[JsonHelper]::Deserialize($item, $depth)
				})
			} catch {
				# If that fails we just take the whole input, concatenate it, and pass it to the parser.
				$Result = [JsonHelper]::Deserialize([string]::join("`n",$ObjectBuffer.ToArray()), $depth)
			}
		}

		# The noenumerate flag allows the returning of an array without unpacking it.
        if ($NoEnumerate) {
			# We have to force return an array otherwise powershell will collapse a one element array
            if ($Result -is [array]) {
                return @(,$result)
            }
        }
        
        return $result
    }
}

Function Invoke-RestMethodFast {
    <#
    .SYNOPSIS
    Connects to a remote host and returns the content of the body casted to objects
    
    .DESCRIPTION
    Connects to a remote host and returns the content of the body casted to objects
    
    .EXAMPLE
    Invoke-RestMethodfast -Uri https://jsonplaceholder.typicode.com/todos/1
    
    .NOTES
    Supports any additional parameters that invoke-webrequest supports. Will only work with JSON, does not work with XML
    #>
	
	# Proxy all of the parameters to invoke-webrequest so that this can be a drop-in for invoke-restmethod
	$params = $MyInvocation.UnboundArguments
	$result = Invoke-WebRequest @params
	
	ConvertFrom-JsonFast -InputObject $Result
}

Set-Alias -Name Invoke-FastRestMethod -Value Invoke-RestMethodFast
Set-Alias -Name ConvertFrom-FastJson -Value ConvertFrom-JsonFast

Export-ModuleMember -Function * -alias *