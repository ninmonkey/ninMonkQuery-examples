// RawInput
let
    Readme = Text.Combine({
        "About:", "The Question was asked in the discord thread: <https://discord.com/channels/511035813589680129/511040430788313088/1096031246871703562>",
        "How can you display this data as a chart with a legend?"
    }, "#(cr,lf,tab)" ),
    Source = Table.FromRows(Json.Document(Binary.Decompress(Binary.FromText("i45WCs5ILEpNUdJRci4tLsnPTS0CMv1Li4qVYnWQJOEMuBSYgUcCVR5TgmiDkNwFZ2LTl4/haGw+wmYassGxAA==", BinaryEncoding.Base64), Compression.Deflate)), let _t = ((type nullable text) meta [Serialized.Text = true]) in type table [#"1 - Data Security" = _t, #"2 - People Security" = _t, #"3 - Server Security" = _t]),
    #"Changed Type" = Table.TransformColumnTypes(Source,{{"1 - Data Security", type text}, {"2 - People Security", type text}, {"3 - Server Security", type text}})
in
    #"Changed Type"

// Security
let
    Source = RawInput,
    #"Added Index" = Table.AddIndexColumn(Source, "Index", 0, 1, Int64.Type),
    #"Unpivoted Other Columns" = Table.UnpivotOtherColumns(#"Added Index", {"Index"}, "Category", "Value"),
    #"Removed Columns" = Table.RemoveColumns(#"Unpivoted Other Columns",{"Index"})
in
    #"Removed Columns"
