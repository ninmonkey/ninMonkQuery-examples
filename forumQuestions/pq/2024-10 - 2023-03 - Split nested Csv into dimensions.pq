let   
    /*
    input: (A,B), (A,B,C), D 
    outputs the table:
        [
            { "Name": "A,B",    "Id":0 },
            { "Name": "A,B,C",  "Id":1 },
            { "Name": "D",      "Id":2 }
        ]

    */
    SplitNestedNames = ( value ) as any => 
        let            
            delim = "),",
            splitFunc = Splitter.SplitTextByDelimiter( delim, QuoteStyle.Csv ),
            segments = splitFunc( value ),            
            cleaned = List.Transform( segments, each Text.TrimStart( Text.Trim(_), "(" ) ),
            unique = List.Sort( List.Distinct( cleaned ) ),
            asTable = Table.FromList(
                unique, Splitter.SplitByNothing(),
                type table [ Name = text ], null, ExtraValues.Error ),
                
            indexed = Table.AddIndexColumn( asTable, "Id", 0, 1, Int64.Type )
        in indexed,

    string = "(A,B), (A,B,C), D ", // your column    
    
    asJson = Text.FromBinary( Json.FromValue( Final ) ),
    
    Final = SplitNestedNames( string )    
in
    Final
