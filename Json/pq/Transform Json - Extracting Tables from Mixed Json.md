## raw_json

```ts
"{#(cr,lf)    ""table"": [#(cr,lf)        {#(cr,lf)            ""columns"": [#(cr,lf)                {#(cr,lf)                    ""column_type"": ""Offer"",#(cr,lf)                    ""id"": ""879"",#(cr,lf)                    ""label"": ""Example Offer Name""#(cr,lf)                },#(cr,lf)                {#(cr,lf)                    ""column_type"": ""Advertiser"",#(cr,lf)                    ""id"": ""135"",#(cr,lf)                    ""label"": ""Example Advertiser Name""#(cr,lf)                },#(cr,lf)                {#(cr,lf)                    ""column_type"": ""Partner"",#(cr,lf)                    ""id"": ""20019"",#(cr,lf)                    ""label"": ""Partner Inc.""#(cr,lf)                }#(cr,lf)            ],#(cr,lf)            ""reporting"": {#(cr,lf)                ""DataPointA"": 0,#(cr,lf)                ""DataPointB"": 75,#(cr,lf)                ""DataPointC"": 75#(cr,lf)            }#(cr,lf)        },#(cr,lf)        {#(cr,lf)            ""columns"": [#(cr,lf)                {#(cr,lf)                    ""column_type"": ""Offer"",#(cr,lf)                    ""id"": ""881"",#(cr,lf)                    ""label"": ""Other Example Name""#(cr,lf)                },#(cr,lf)                {#(cr,lf)                    ""column_type"": ""Advertiser"",#(cr,lf)                    ""id"": ""135"",#(cr,lf)                    ""label"": ""Example Advertiser Name""#(cr,lf)                },#(cr,lf)                {#(cr,lf)                    ""column_type"": ""Partner"",#(cr,lf)                    ""id"": ""20017"",#(cr,lf)                    ""label"": ""Other Partner Inc.""#(cr,lf)                }#(cr,lf)            ],#(cr,lf)            ""reporting"": {#(cr,lf)                ""DataPointA"": 100,#(cr,lf)                ""DataPointB"": 200,#(cr,lf)                ""DataPointC"": 300#(cr,lf)            }#(cr,lf)        }#(cr,lf)    ]#(cr,lf)}"
```
## xray
```ts
let 
    Summarize = (source as any, optional verbose as logical) as text => [
            bytes = Json.FromValue(source, TextEncoding.Utf8),
            str = Text.FromBinary(bytes, TextEncoding.Utf8),
            verbose_str = Text.Replace( str, ",", ",#(cr,lf)"),
            return = if verbose = true then verbose_str else str
        ][return]
in
    Summarize
```
## base

```ts
let
    /*
    about:
        how to parse, and drill down mixed json types

    context: a discord thread: <https://discord.com/channels/511035813589680129/521349691359887363/1064708864429277235>
    */

    Source = raw_json,
    parsed = Json.Document(Source),
    schema = type table[columns = (type {any}), reporting = Record.Type],
    table = Table.FromRecords( parsed[table], schema, MissingField.Error )
in
    table
```
## main_b
```ts
let
    Source = base,
    #"Removed Other Columns" = Table.SelectColumns(Source,{"columns"}),
    #"Expanded columns" = Table.ExpandListColumn(#"Removed Other Columns", "columns"),
    Custom1 = Table.FromRecords( #"Expanded columns"[columns] ),
    #"Changed Type" = Table.TransformColumnTypes(Custom1,{{"column_type", type text}, {"label", type text}, {"id", Int64.Type}})
in
    #"Changed Type"
```
## main_a
```ts
let
    Source = base,
    #"Removed Other Columns" = Table.SelectColumns(Source,{"reporting"}),
    #"Expanded reporting" = Table.ExpandRecordColumn(#"Removed Other Columns", "reporting", {"DataPointA", "DataPointB", "DataPointC"}, {"reporting.DataPointA", "reporting.DataPointB", "reporting.DataPointC"}),
    #"Changed Type1" = Table.TransformColumnTypes(#"Expanded reporting",{{"reporting.DataPointA", Int64.Type}, {"reporting.DataPointB", Int64.Type}, {"reporting.DataPointC", Int64.Type}})
in
    #"Changed Type1"