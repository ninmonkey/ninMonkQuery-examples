// Sample
let
    Source = Table.FromRows(Json.Document(Binary.Decompress(Binary.FromText("jY69CsAgDIRfRZwPSRvFsQ8ijp2FvP/Q+ANCK22ny3deLqZkNwITWSyHqhk1xN5156kzgmHdtQWIItgHtVZTVDFFzClS5OiNO1g7QtATe236ZMVBfX8yflPfdGo4dTDe37l92uZ8AQ==", BinaryEncoding.Base64), Compression.Deflate)), let _t = ((type nullable text) meta [Serialized.Text = true]) in type table [#"Raw Text" = _t, US = _t, German = _t, Expecting = _t]),

    #"Changed Type with culture US" = Table.TransformColumnTypes(Source,{
        {"US", type number}},      "en-us"),

    #"Changed Type with culture German" = Table.TransformColumnTypes(#"Changed Type with culture US", {
        {"German", type number}}, "de-de"),

    #"col Summary" = Table.AddColumn(
        #"Changed Type with culture German", "Delta",
        (row) => try
            ( row[US] - row[German] )
        catch (e) =>
            e[Message] as text

        ,type text)
in
    #"col Summary"