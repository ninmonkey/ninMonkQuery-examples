
Almost done, 2nd query needs final nested type declaration

## // blog📌example tut using types
```ts
let
    Source = #table(
        type table [ Name = text ],
        {
            {"Bob"}, {"Jen"}
        }),
    #"Add BadColType" = Table.AddColumn(Source, "BadType", each { 0..2 }),
    #"Add GoodType Nested number" = Table.AddColumn(
        #"Add BadColType", "GoodType Money",
        each 
            { 1234.22, 344521.92 },
            (type { number })    
    ),
    #"Add GoodType Nested Currency" = Table.AddColumn(
        #"Add GoodType Nested number", "GoodType Nested Currency",
        each 
            { 1234.22, 344521.92 },
            (type { Currency.Type })
    ),
    
    #"Expanded BadType" = Table.ExpandListColumn(#"Add GoodType Nested Currency", "BadType"),
    #"Expanded GoodType Money" = Table.ExpandListColumn(#"Expanded BadType", "GoodType Money"),
    #"Expanded GoodType Nested Currency" = Table.ExpandListColumn(#"Expanded GoodType Money", "GoodType Nested Currency")
in
    #"Expanded GoodType Nested Currency"
```

## blog📌example 2 fancy json types

```ts
let
    Source = #table(
        type table [ Name = text ],
        { {"Bob"} }
    ),
   
   // 
    #"Add GoodType Nested Currency" = Table.AddColumn(
        Source, "API Response",
        each 
            { 1234.22, 344521.92 },
            (type { Currency.Type })
    ),   
    json_fake_response = "[#(cr,lf)    {#(cr,lf)        ""EventId"": 2345,#(cr,lf)        ""User"": {#(cr,lf)            ""Name"": ""Bob"",#(cr,lf)            ""Id"": 32#(cr,lf)        }#(cr,lf)    },#(cr,lf)    {#(cr,lf)        ""EventId"": 93235,#(cr,lf)        ""User"": {#(cr,lf)            ""Name"": ""Jen"",#(cr,lf)            ""Id"": 32#(cr,lf)        }#(cr,lf)    }]",
    fake_response = Json.Document( json_fake_response, TextEncoding.Utf8 ),
    // #"Start of Bad1" = Table.AddColumn( Source, "NestedJson", (row) => json),
    // #"Expanded NestedJson" = Table.ExpandListColumn(#"Start of Bad1", "NestedJson"),
    // #"Expanded NestedJson1" = Table.ExpandRecordColumn(#"Expanded NestedJson", "NestedJson", {"EventId", "User"}, {"NestedJson.EventId", "NestedJson.User"}),
    // #"Final1 of bad Types" = Table.ExpandRecordColumn(#"Expanded NestedJson1", "NestedJson.User", {"Name", "Id"}, {"NestedJson.User.Name", "NestedJson.User.Id"}),
    json_schema = type {
        [
            EventId = number, User = text
        ]
    },
    WebResponse_typeAny = Table.AddColumn( Source, "GoodNestedType", (row) => fake_response, type any),
    WebResponse = Table.AddColumn( Source, "GoodNestedType", (row) => fake_response, json_schema),
    #"Expanded GoodNestedType" = Table.ExpandListColumn(WebResponse, "GoodNestedType"),
    #"Expanded GoodNestedType1" = WebResponse_typeAny,
    #"Expanded GoodNestedType2" = Table.ExpandListColumn(#"Expanded GoodNestedType1", "GoodNestedType"),
    #"Expanded GoodNestedType3" = Table.ExpandRecordColumn(#"Expanded GoodNestedType2", "GoodNestedType", {"EventId", "User"}, {"GoodNestedType.EventId", "GoodNestedType.User"}),
    #"Expanded GoodNestedType.User" = Table.ExpandRecordColumn(#"Expanded GoodNestedType3", "GoodNestedType.User", {"Name", "Id"}, {"GoodNestedType.User.Name", "GoodNestedType.User.Id"})
in
    #"Expanded GoodNestedType.User"
    // #"Expanded GoodType Nested Currency"
```