let
    /*
    Does it start with "fort" followed by any number? 
    examples:
        fort2   : true
        ffort2  : false
        FORT9   : true
          fort9 : false
    */
    Text.HasFortPrefix = ( source as text) as any => [
        digitsAsText  = {"0".."9"},
        textPrefix    = Text.StartsWith( source, "fort", Comparer.OrdinalIgnoreCase ),
        hasFirstChar  = Text.Length( source ) > 4,
        hasDigit      = List.Contains( digitsAsText, Text.At(source, 4) ),
        return =
            textPrefix and hasFirstChar and hasDigit
    ][return],

    Source = Table.FromRows(Json.Document(Binary.Decompress(Binary.FromText("i45WcssvKjFSitWBsEzgLAVLYzA7LQ2kwNgUIqOgAOFagnlFSrGxAA==", BinaryEncoding.Base64), Compression.Deflate)), let _t = ((type nullable text) meta [Serialized.Text = true]) in type table [Text = _t]),
    #"Added Custom" = Table.AddColumn(Source, "Test", each not Text.HasFortPrefix( [Text] ), Logical.Type )
in
    #"Added Custom"