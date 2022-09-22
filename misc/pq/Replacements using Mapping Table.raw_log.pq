let
    Source_RawLog = Table.FromRows(Json.Document(Binary.Decompress(Binary.FromText("i45WcszNr8hMzszJycxT0EgsVjBUcFTQVIrVwSbjjFNGAY8uhEwBskRxfkppLhYpoFkwWaBkLAA=", BinaryEncoding.Base64), Compression.Deflate)), let _t = ((type nullable text) meta [Serialized.Text = true]) in type table [#"Raw Name" = _t]),
    MapPartialMatch = Table.FromRows(Json.Document(Binary.Decompress(Binary.FromText("i45WcszNr8hMzszJycxT0gHzKiE8BQ3HYoWQosyMypSixJJUBU2lWB2Q8gJk1TAOWHFwfkpmaS5QXSwA", BinaryEncoding.Base64), Compression.Deflate)), let _t = ((type nullable text) meta [Serialized.Text = true]) in type table [Partial = _t, #"New Value" = _t]),


    Text.ReplacePartialMatches = Value.ReplaceType( Text.ReplacePartialMatches_impl, Text.ReplacePartialMatches.Type ),
    Text.ReplacePartialMatches.Type = type function(
        source as text,
        mapping as Table.Type
    ) as text meta [
        Documentation.Name = "Text.ReplacePartialMatches",
        Documentation.LongDescription = Text.Combine({
            "Test strings for partial text matches. Replace the entire cell/value with the new replacement text.",
            "",
            "Mapping table requires two columns: <code>[Partial]</code> and <code>[New Value]</code> "

        }, "<br>")
        // Documentation.Examples = {
        //     [Description = "example1", Code = huge_doc_example1,
        //      Result = "result"]
        // }
    ],

    Text.ReplacePartialMatches_impl = ( source as text, mapping as table ) as text =>
        // todo: performance, end on very first replacement
        let
            mappingList = Table.ToRecords( mapping ),
            result = List.Accumulate(
                mappingList,
                source,
                (state, cur) =>
                    if Text.Contains( state, cur[Partial], Comparer.OrdinalIgnoreCase )
                    then cur[New Value] else state
            )
        in result,

    TestReplace = Table.AddColumn(Source_RawLog, "Clean Name",
        (row) =>
            Text.ReplacePartialMatches(
                row[Raw Name], MapPartialMatch),
            type text),

    huge_doc_example1 = "let#(cr)#(lf)    Source_RawLog = Table.FromRows(Json.Document(Binary.Decompress(Binary.FromText(""i45WcszNr8hMzszJycxT0EgsVjBUcFTQVIrVwSbjjFNGAY8uhEwBskRxfkppLhYpoFkwWaBkLAA="", BinaryEncoding.Base64), Compression.Deflate)), let _t = ((type nullable text) meta [Serialized.Text = true]) in type table [#""Raw Name"" = _t]),#(cr)#(lf)    MapPartial = Table.FromRows(Json.Document(Binary.Decompress(Binary.FromText(""i45WcszNr8hMzszJycxT0gHzKiE8BQ3HYoWQosyMypSixJJUBU2lWB2Q8gJk1TAOWHFwfkpmaS5QXSwA"", BinaryEncoding.Base64), Compression.Deflate)), let _t = ((type nullable text) meta [Serialized.Text = true]) in type table [Partial = _t, #""New Value"" = _t]),#(cr)#(lf)#(cr)#(lf)    TestReplace = Table.AddColumn(Source_RawLog, ""Clean Name"",#(cr)#(lf)        (row) =>#(cr)#(lf)            Text.ReplacePartialMatches(#(cr)#(lf)                row[Raw Name], MapPartial),#(cr)#(lf)            type text)#(cr)#(lf)in#(cr)#(lf)    TestReplace#(cr)#(lf)    "
in
    TestReplace