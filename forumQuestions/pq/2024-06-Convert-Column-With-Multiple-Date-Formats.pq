    let
        Source = Table.FromRows(Json.Document(Binary.Decompress(Binary.FromText("i45WMjIwMtE1MNY1NFGK1YlWArN0QYJKsbEA", BinaryEncoding.Base64), Compression.Deflate)), let _t = ((type nullable text) meta [Serialized.Text = true]) in type table [DateString = _t]),
        #"Changed Type" = Table.TransformColumnTypes(Source,{{"DateString", type text}}),
        format1 = "yyyy-MM-dd",
        format2 = "MM-dd-yyyy",

        #"Added Custom" = Table.AddColumn(#"Changed Type", "Date", 
            (row) => 
                try 
                    Date.FromText( row[DateString], [ Format = format1,  Culture = "en-us" ] )
                catch (e1) => 
                    try 
                        Date.FromText( row[DateString], [ Format = format2, Culture = "en-us" ] )
                    catch (e2) => error "Failed both dates",
            type date           
        )
    in
        #"Added Custom"
