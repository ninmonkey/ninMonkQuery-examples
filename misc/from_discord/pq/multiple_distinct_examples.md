- [Function: `DistinctCodesPerYear`](#function-distinctcodesperyear)
- [Table: `Base`](#table-base)
- [Table: `Group`](#table-group)
- [Table: Using `DistinctCodesPerYear`](#table-using-distinctcodesperyear)



## Function: `DistinctCodesPerYear`

```powerquery
    DistinctCodesPerYear = ( source as table, year as number ) as list =>
        let 
            filter_year = Table.SelectRows( source, each [Year] = year ),
            distinct_codes = List.Distinct( filter_year[Code] )
        in 
            distinct_codes         
```

## Table: `Base`

```powerquery
let
    Source = Table.FromRows(Json.Document(Binary.Decompress(Binary.FromText("fc49DsIwDAXgu3juQHOdKkNCLWOR2JUJRL09TJUDqOP75J+3LBAuIcAELCuTQpwOyeWJPqea0Tz0G7djYv6AWhIaxHD1G1fj+lDxRIY4QEYeb2wsd59rIpSW/M7Xm5+mZGk/y396ZdN+3uvFWrB52bEU7RDjGw==", BinaryEncoding.Base64), Compression.Deflate)), let _t = ((type nullable text) meta [Serialized.Text = true]) in type table [Year = _t, Code = _t]),
    #"add type" = Table.TransformColumnTypes(Source,{{"Year", Int64.Type}}),
    #"col Index" = Table.AddIndexColumn(#"add type", "Index", 0, 1, Int64.Type)
in
    #"col Index"
```    

## Table: `Group`

```powerquery
// Using Group
let
    Source = Base,
    #"Grouped Rows" = Table.Group(Source, {"Year"}, {{"Codes", each _[Code], type table [Year=nullable number, Code=nullable text, Index=number]}}),
    #"Added Custom" = Table.AddColumn(#"Grouped Rows", "Preview As Csv", each Text.Combine( [Codes], ", "), type text)
in
    #"Added Custom"
```

## Table: Using `DistinctCodesPerYear`

```powerquery
let
    Source = Base,
    /* original done on 1 year manually */
    Custom1 = Source,
    #"Filtered Rows" = Table.SelectRows(Custom1, each ([Year] = 2021)),
    #"Removed Other Columns" = Table.SelectColumns(#"Filtered Rows",{"Year", "Code"}),
    Custom2 = Table.Distinct( #"Removed Other Columns" ),
    Custom3 = Custom2,
    

    /* using functions */
    DistinctCodesPerYear = ( source as table, year as number ) as list =>
        let 
            filter_year = Table.SelectRows( source, each [Year] = year ),
            distinct_codes = List.Distinct( filter_year[Code] )
        in 
            distinct_codes,
            
    Summary = [
        #"DistinctCodesPerYear for 2021" = DistinctCodesPerYear( Source, 2021 ),
        #"2021 preview as csv" = Text.Combine( #"DistinctCodesPerYear for 2021" , ", " ),

        #"DistinctCodesPerYear for 2022" = DistinctCodesPerYear( Source, 2022 ),
        #"2022 preview as csv" = Text.Combine( #"DistinctCodesPerYear for 2022" , ", " ),

        #"DistinctCodesPerYear for null" = DistinctCodesPerYear( Source, 0 )
    ]
in
    Summary
```
