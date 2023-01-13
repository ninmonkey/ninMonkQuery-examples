let    
    PartialMapping = Table.FromRows(Json.Document(Binary.Decompress(Binary.FromText("i45WcszNr8hMzszJycxT0gHzKiE8BQ3HYoWQosyMypSixJJUBU2lWB2Q8gJk1TAOWHFwfkpmaS5QXSwA", BinaryEncoding.Base64), Compression.Deflate)), let _t = ((type nullable text) meta [Serialized.Text = true]) in type table [Partial = _t, #"New Value" = _t])
in
    PartialMapping