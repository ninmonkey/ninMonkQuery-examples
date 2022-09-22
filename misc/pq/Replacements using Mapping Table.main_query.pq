let
    Text.ReplacePartialMatch = Text_ReplacePartialMatch, // just an alias

    Source = Table.FromRows(Json.Document(Binary.Decompress(Binary.FromText("i45WcszNr8hMzszJycxT0EgsVjBUcFTQVIrVwSbjjFNGAY8uhEwBskRxfkppLhYpoFkwWaBkLAA=", BinaryEncoding.Base64), Compression.Deflate)), let _t = ((type nullable text) meta [Serialized.Text = true]) in type table [#"Raw Name" = _t]),

    PartialMapping = Table.FromRows(Json.Document(Binary.Decompress(Binary.FromText("i45WcszNr8hMzszJycxT0gHzKiE8BQ3HYoWQosyMypSixJJUBU2lWB2Q8gJk1TAOWHFwfkpmaS5QXSwA", BinaryEncoding.Base64), Compression.Deflate)), let _t = ((type nullable text) meta [Serialized.Text = true]) in type table [Partial = _t, #"New Value" = _t]),

    FinalTable = Table.AddColumn(Source, "Clean Name",
        (row) => Text.ReplacePartialMatch(
                row[Raw Name], PartialMapping),
            type text)
in
    FinalTable