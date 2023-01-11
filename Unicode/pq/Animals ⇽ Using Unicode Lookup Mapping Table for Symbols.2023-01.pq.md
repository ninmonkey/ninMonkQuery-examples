## Table: `Unicode`

```typescript
let
    /* 
    @('🐈', '🐕', '🐍', '🐸', '🐢' -join '') | % EnumerateRunes
    */
    items = {
        [ Name = "Cat",        Rune = "#(0001f408)" ], 
        [ Name = "Dog",        Rune = "#(0001f415)" ], 
        [ Name = "Snake",      Rune = "#(0001f40d)" ], 
        [ Name = "Frog",       Rune = "#(0001f438)" ], 
        [ Name = "Turtle",     Rune = "#(0001f422)" ], 
        [ Name = "CR",         Rune = "#(cr)" ], 
        [ Name = "CR Symbol",  Rune = "#(240d)" ], 
        [ Name = "NL",         Rune = "#(lf)" ], 
        [ Name = "NL Symbol",  Rune = "#(240a)" ], 
        [ Name = "CRNL",       Rune = "#(cr,lf)" ], 
        [ Name = "CRNL Symbol",Rune = "#(240d,240a)" ], 
        [ Name = "Null Symbol",Rune = "#(2400)" ],
        [ Name = "Zebra",      Rune = Character.FromNumber( 0x1f993) ], 
        [ Name = "Confused",   Rune = "#(0001f635)" ]
    },
    Source = Table.FromRecords(
        items, type table [ Name = text, Rune = text ], MissingField.Error ),
    column_codepoint = Table.AddColumn( Source, "Codepoint",
        (row) => Character.ToNumber( row[Rune] ), Int64.Type),
    
    maybeProper = if #"AutoCase All Text" then Table.TransformColumns( column_codepoint, {
        {"Name", Text.Proper, type text}}) else column_codepoint
in
    maybeProper
```


## Table: `Animal`
```typescript
let
    Source = Table.FromRows(Json.Document(Binary.Decompress(Binary.FromText("PY5BCsNACEXv4npO0YYUSkog7aYMs7BEsqhoMBNCb1+dQjf6/3+K5gxnrJBgotnrhUmgpAydLmGN3CfozWnEd8E3eTAayhLiSiKfhnprK09i1sPFDe0HHrtVjtkT79EGUkGbtcFBX1sl+z/gB9YNSvkC", BinaryEncoding.Base64), Compression.Deflate)), let _t = ((type nullable text) meta [Serialized.Text = true]) in type table [Species = _t, Color = _t, Name = _t]),
    #"Changed Type" = Table.TransformColumnTypes(
        Source,{{"Species", type text}, {"Color", type text}}),

    #"Added Index" = Table.AddIndexColumn(#"Changed Type", "Index", 0, 1, Int64.Type),
    #"Renamed Columns" = Table.RenameColumns(#"Added Index",{{"Index", "Id"}}),

    #"Capitalized Each Word" = Table.TransformColumns(#"Renamed Columns",{
        {"Name", Text.Proper, type text},
        {"Color", Text.Proper, type text},
        {"Species", Text.Proper, type text} }),

    maybeProper = if #"AutoCase All Text" then #"Capitalized Each Word" else #"Renamed Columns"
    
in
    maybeProper
```

## Parameter `AutoCase All Text`

```typescript
false meta [IsParameterQuery=true, List={false, true}, DefaultValue=false, Type="Logical", IsParameterQueryRequired=true]
```

## Generating codepoints using Powershell

```ps1
Pwsh>  '🐈🐕🐍🐸🐢'.EnumerateRunes().value | Join-String -FormatString '0x{0:x}' -sep ', '
```
output:
```
0x1f408, 0x1f415, 0x1f40d, 0x1f438, 0x1f422
```
