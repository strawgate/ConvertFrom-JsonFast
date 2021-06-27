Add-Type -TypeDefinition @"
using System.Collections;
using System.Linq;
using System;
using System.IO;
using System.Text.Json;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

public static class JsonHelper
{
    public static object Deserialize(string json)
    {
        JsonDocument thisDocument = JsonDocument.Parse(json);

        return ToObject(thisDocument.RootElement);
    }

    public static object ToObject(JsonElement element)
    {
        JsonValueKind thisKind = element.ValueKind;

        switch (element.ValueKind) {
            case JsonValueKind.Object:
                var Properties = element.EnumerateObject();

                return Properties.ToDictionary(prop => prop.Name,
                    prop => ToObject(prop.Value)
                );
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
		$InputObject
	)
	
	[JsonHelper]::Deserialize($InputObject)
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
	$params = $MyInvocation.UnboundArguments
	$result = Invoke-WebRequest @params
	
	ConvertFrom-JsonFast -InputObject $Result
}