let
    Source = Table.FromRows(Json.Document(Binary.Decompress(Binary.FromText("i45WcszNr8hMzszJycxT0EgsVjBUcFTQVIrVwSbjjFNGAY8uhEwBskRxfkppLhYpoFkwWaBkLAA=", BinaryEncoding.Base64), Compression.Deflate)), let _t = ((type nullable text) meta [Serialized.Text = true]) in type table [#"Raw Name" = _t]),
    #"Replace With Map" = Table.AddColumn(Source, "Clean Name",
        (row) => Text_ReplacePartialMatch(
                row[Raw Name], #"Mapping Table"),
            type text)
in
    #"Replace With Map"