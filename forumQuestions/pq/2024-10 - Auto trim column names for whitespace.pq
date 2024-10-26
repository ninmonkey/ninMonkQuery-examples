let
    // ignore this step, it's just "enter-data" which is JSON
    Source = Table.FromRows(Json.Document(Binary.Decompress(Binary.FromText("i45WSspPUtJRyi9KzEtPVUjKKU0F8hKVYnWilbJS84DsotQUIJmkFBsLAA==", BinaryEncoding.Base64), Compression.Deflate)), let _t = ((type nullable text) meta [Serialized.Text = true]) in type table [#"   User  " = _t, #"    Color " = _t, #" has Newline  #(lf)#(lf)" = _t]),

    // the real code
    #"Cleanup Blank ColumnNames" =
        Table.TransformColumnNames( Source,  each Text.Trim( _ ) )
in
    #"Cleanup Blank ColumnNames"