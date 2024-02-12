let
    // ignore this, it's just JSON from "enter data"
    Json = Table.FromRows(Json.Document(Binary.Decompress(Binary.FromText("i45WCnRS0lEyUXAqSi0pUXBLLCtKBfJNgdglyBXEMlfwSizOz1PwKM0rSS0CipgpxcYCAA==", BinaryEncoding.Base64), Compression.Deflate)), let _t = ((type nullable text) meta [Serialized.Text = true]) in type table [Column1 = _t, Column2 = _t, Column3 = _t, Column4 = _t, Column5 = _t, Column6 = _t]),
    Source  =
        Table.TransformColumnTypes(Json,{
            {"Column1", type text}, {"Column2", type text}, {"Column3", Int64.Type},
            {"Column4", type text}, {"Column5", type text}, {"Column6", Int64.Type} }),

    // code starts here
    left    = Table.SelectColumns( Source, {"Column1", "Column2", "Column3"}, MissingField.Error),
    right   = Table.SelectColumns( Source, {"Column4", "Column5", "Column6"}, MissingField.Error),

    // Table column names must match before appending the queries
    right_renamed = Table.RenameColumns(right,{
            {"Column4", "Column1"},
            {"Column5", "Column2"},
            {"Column6", "Column3"} }),

    merged  = Table.Combine({ left, right_renamed } )
in
    merged