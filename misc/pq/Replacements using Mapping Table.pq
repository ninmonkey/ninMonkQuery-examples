let
    Source_RawLog = Table.FromRows(Json.Document(Binary.Decompress(Binary.FromText("i45WcszNr8hMzszJycxT0EgsVjBUcFTQVIrVwSbjjFNGAY8uhEwBskRxfkppLhYpoFkwWaBkLAA=", BinaryEncoding.Base64), Compression.Deflate)), let _t = ((type nullable text) meta [Serialized.Text = true]) in type table [#"Raw Name" = _t]),
    MapPartialMatch = Table.FromRows(Json.Document(Binary.Decompress(Binary.FromText("i45WcszNr8hMzszJycxT0gHzKiE8BQ3HYoWQosyMypSixJJUBU2lWB2Q8gJk1TAOWHFwfkpmaS5QXSwA", BinaryEncoding.Base64), Compression.Deflate)), let _t = ((type nullable text) meta [Serialized.Text = true]) in type table [Partial = _t, #"New Value" = _t]),


    // replacer = replre,
    // Replacer.PartialMapping = ReplacePartialMatch, // I am not sure what name I want
    // ReplacePartialMatch = repl
    Text.ReplacePartialMatches = ( source as text, mapping as table ) as text =>
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


    // Text.ReplaceMany = ( source as text, mapping as list ) as text =>
    //     let
    //         result = List.Accumulate(
    //             mapping, source,
    //             // ( state, cur ) => Text.Replace( state, cur{0}, cur{1} ))
    //             ( state, cur ) => if Text.Contains( state, cur{0}, Comparer.OrdinalIgnoreCase ) then cur{1} else state

    //                                 ) //, cur{1} ))
    //     in
    //         result,

    // tryReplace0 = Table.AddColumn(Source_RawLog, "Clean Name",
    //     (row) =>
    //         Text.ReplaceMany(
    //             row[Raw Name], MapPartialMatch),
    //         type text),

    // replacements = List.Zip( { MapPartialMatch[Partial], MapPartialMatch[New Value] } ),
    TestReplace = Table.AddColumn(Source_RawLog, "Clean Name",
        (row) =>
            Text.ReplacePartialMatches(
                row[Raw Name], MapPartialMatch),
            type text)
in
    TestReplace