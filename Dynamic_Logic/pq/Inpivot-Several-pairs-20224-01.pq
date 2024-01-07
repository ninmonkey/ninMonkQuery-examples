[

    RawOriginal = Table.FromRows( Json.Document( Binary.Decompress(
        Binary.FromText("i45W8shMz1AoyS9QCM5LTcxOLVLSUXJKzEnMzkksSwSyTfUN9Y2MIQwDOAvGMDIGsWJ1opV88suRTSkGSvvlKyQVZeYqZCSWAHlmMF1m+qYwBlwEYnRsLAA=",
        BinaryEncoding.Base64), Compression.Deflate)),
        let
            _t = ((type nullable text) meta [Serialized.Text = true])
        in
            type table [
                #"Item Type" = _t,
                #"Item Name" = _t,
                #"Shoe Inv. Date" = _t,
                #"Shoe Sell Date" = _t,
                #"Hat Inv Date" = _t,
                #"Hat Sell Date" = _t ] ),

    typed = Table.TransformColumnTypes(RawOriginal,{
        {"Shoe Inv. Date", type date}, {"Shoe Sell Date", type date}, {"Hat Inv Date", type date},
        {"Hat Sell Date", type date}, {"Item Type", type text}, {"Item Name", type text} }, "en-US" ),
    renamed =
        Table.RenameColumns( typed ,{
            { "Shoe Inv. Date", "Shoe Inv Date"}
        }),
    final = renamed
]