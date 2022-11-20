let
    /*
    this is a helper function, to import an external .pq script
    then you're able to externally editing queries /w excel.

    usage:
        ImportPq.FromFile("C:\docs\external-script.pq")

    */
    ImportPq.FromFile = (filepath as text, optional encoding as nullable number) as any =>
        let
            bytes = File.Contents(filepath),
            rawText = Text.FromBinary( bytes, (encoding ?? TextEncoding.Utf8) ),
            // or = Expression.Evaluate( rawText, #sections[Section1] )
            eval = Expression.Evaluate( rawText, #shared )
        in
            eval
in
    ImportPq.FromFile