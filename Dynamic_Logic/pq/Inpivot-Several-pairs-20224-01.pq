let
    RawSource = [
        RawOriginal = Table.FromRows( Json.Document( Binary.Decompress(
            Binary.FromText("i45W8shMz1AoyS9QCM5LTcxOLVLSUXJKzEnMzkksSwSyTfUN9Y2MIQwDOAvGMDIGsWJ1opV88suRTSkGSvvlKyQVZeYqZCSWAHlmMF1m+qYwBlwEYnRsLAA=",
            BinaryEncoding.Base64), Compression.Deflate)),
            let
                _t = ((type nullable text) meta [Serialized.Text = true])
            in
                type table [
                    #"Shoe Type" = _t,
                    #"Hat Type" = _t,
                    #"Shoe Inv Date" = _t,
                    #"Shoe Sell Date" = _t,
                    #"Hat Inv Date" = _t,
                    #"Hat Sell Date" = _t ] ),

        typed = Table.TransformColumnTypes(RawOriginal,{
            {"Shoe Inv Date",   type date }, { "Shoe Sell Date",    type date },
            {"Hat Inv Date",    type date }, { "Hat Sell Date",     type date },
            {"Shoe Type",        type text}, { "Hat Type",          type text}
            }, "en-US" ),
        Final = typed
    ],
        final = RawSource[Final]
    in
        final