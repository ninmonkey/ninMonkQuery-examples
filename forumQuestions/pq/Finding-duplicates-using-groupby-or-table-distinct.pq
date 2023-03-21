// Data
let
    Source = Table.FromRows(Json.Document(Binary.Decompress(Binary.FromText("i45WcspPUtJRclSK1YGxncBsr9Q8ONsbiQ0Rd4aIJxYh8zKLsoGcKCSjgMbGAgA=", BinaryEncoding.Base64), Compression.Deflate)), let _t = ((type nullable text) meta [Serialized.Text = true]) in type table [Name = _t, Region = _t]),
    #"Changed Type" = Table.TransformColumnTypes(Source,{{"Name", type text}, {"Region", type text}}),
    SourceBase = Table.AddIndexColumn(#"Changed Type", "Id", 0, 1, Int64.Type),
    #"UsingDistinct📌" = Table.Distinct( SourceBase, {"Name", "Region"} ),
    #"Using Group📌" = Table.Group(SourceBase, {"Name", "Region"}, {{"Records", each Table.RowCount(_), Int64.Type}}),
    #"Select Unique 📌" = Table.SelectRows(#"Using Group📌", each ([Records] = 1)),
    #"Drop Unique📌" = Table.SelectRows(#"Using Group📌", each ([Records] <> 1))
in
    #"Drop Unique📌"
