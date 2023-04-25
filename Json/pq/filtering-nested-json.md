
### Final Filter

- That's a lot of drill downs, so I wrapped it in a `catch` statement.
- Depending on your case, you may want errors to coerce to nulls, or
- Other instances you want to raise exceptions -- instead of coercing to null or text

```ts
let
    Source = Base,
    ExpandObject = Table.ExpandListColumn(Source, "Object"),
    SelectRows = Table.SelectRows( 
        ExpandObject,
        (row) => 
            try row[Object][mainRecord]{0}[subRecord]?[myBoolean]?
            catch (e) => e[Message]
            // catch (e) => e // or if you want to keep the error record
    )
in
    SelectRows
```

### Base Query

This query 
- Toggles between good / bad json inputs
- Declares the nested schema used by the json 

```ts
let
    DocJson = "[{""User"": ""A"",#(cr)#(lf)#(tab)""Object"":[#(cr)#(lf)#(tab)#(tab){""id"": ""ap1"",""mainRecord"": [{""subRecord"": {""myBoolean"": true}}]},#(cr)#(lf)#(tab)#(tab){""id"": ""ap2"",""mainRecord"": [{""subRecord"": {""myBoolean"": false}}]}#(cr)#(lf)#(tab)]#(cr)#(lf)},#(cr)#(lf){""User"": ""B"",#(cr)#(lf)#(tab)""Object"":[#(cr)#(lf)#(tab)#(tab){""id"": ""ap1"",""mainRecord"": [{""subRecord"": {""myBoolean"": false}}]},#(cr)#(lf)#(tab)#(tab){""id"": ""ap2"",""mainRecord"": [{""subRecord"": {""myBoolean"": false}}]}#(cr)#(lf)#(tab)]#(cr)#(lf)}]",
    BrokenJson = "[{""User"": ""A"",#(cr)#(lf)#(tab)""Object"":[#(cr)#(lf)#(tab)#(tab){""id"": ""ap1"",""mainRecord"": [{""cat"": {""myBoolean"": true}}]},#(cr)#(lf)#(tab)#(tab){""id"": ""ap2"",""mainRecord"": [{""subRecord"": {""fdsf"": false}}]}#(cr)#(lf)#(tab)]#(cr)#(lf)},#(cr)#(lf){""User"": ""B"",#(cr)#(lf)#(tab)""Object"":[#(cr)#(lf)#(tab)#(tab){""id"": ""ap1"",""mainRecord"": [{""subRecord"": {""myBoolean"": false}}]},#(cr)#(lf)#(tab)#(tab){""id"": ""ap2"",""mainRecord"": [{""subRecord"": {""myBoolean"": false}}]}#(cr)#(lf)#(tab)]#(cr)#(lf)}]",

    //toggle an alternate json doc, to test error handling
    SourceGood = Json.Document( DocJson , TextEncoding.Utf8 ),
    SourceBad = Json.Document( BrokenJson , TextEncoding.Utf8 ),
    Source  = if false then SourceBad else SourceGood,

    /*
        schema type is not mandatory to run
    */
    subRecord_type = type [
        subRecord = [
            myBoolean = logical
        ]
    ],
    mainRecord_type = (type { subRecord_type } ),
    item_type = type [ 
        id = text,
        mainRecord = mainRecord_type
    ],
    object_type = type { item_type },    
    schema = type table[
        User = text,
        Object = object_type
    ],

    BaseTable = Table.FromRecords(Source, schema, MissingField.Error)
in
    BaseTable
```

### Using x-ray to confirm and debug

```js
let
    Source = Base,
    // preview element jsonified, then back to text
    Summarize = (source as any) as text => [
            bytes = Json.FromValue(source, TextEncoding.Utf8),
            str = Text.FromBinary(bytes, TextEncoding.Utf8)
        ][str],
        
    #"Expanded Object" = Table.ExpandListColumn(Source, "Object"),
    #"xray-nested" = Table.AddColumn(
        #"Expanded Object", "Str",
        (_) as text => Summarize( [Object] )),
    
    #"grab nested bool" = Table.AddColumn(
        #"xray-nested", "GrabBool",
        (row) =>
            row[Object][mainRecord] {  0  } [subRecord] 
[myBoolean], type record)
in
    #"grab nested bool"
```
