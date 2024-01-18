    let
        // your excel function
        TransformExcel = (source as any) =>
            source,

        // your csv function
        TransformCsv = (source as any) =>
            source,

        // this function delegates loading depending on the filetype
        // I used AddColumn so that you can see the input
        // but you can easily use "TransformColumns" too
        DecideTransformKind = ( row as record ) => 
            let
                isExcel = ".ps1" = Text.Lower( row[Extension] ),
                isCsv   = ".csv"  = Text.Lower( row[Extension] ),
                transformFile =  
                    if isExcel    then TransformExcel( row[Content] )
                    else if isCsv then TransformCsv( row[Content] )
                    else error [Message.Format = "Unexpected file type! {0}", Message.Parameters = { row[Extension] }]
            in
                transformFile,

        Source    = Folder.Contents("g:\temp"),
        LoadFiles = Table.AddColumn( Source, "ParsedFile", (row) => DecideTransformKind(row), type any )


    in
        LoadFiles
