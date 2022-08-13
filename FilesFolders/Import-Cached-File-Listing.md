## About

The user requires recursive file listings, but that was very expensive, and over the network. Instead, pre-calculate the filepaths:


```ps1
Pwsh7> gci -Path 'c:\nin_temp' *.pdf -Recurse -File -Force
    | Select Name, LastWriteTime, FullName
    | Export-Csv 'C:\nin_temp\fileListing.csv'
```
- `-force` includes hidden
- `-file` means save the full filepath, filtering out folder-only results

## Import Query

```TS
let
    /*
    Pwsh command was: (force includes hidden)
    "gci 'c:\nin_temp' *.pdf -Recurse -File -Force
        | Select Name, LastWriteTime, FullName
        | Export-Csv 'fileListing.csv'",

    */
    CsvPath = "C:\nin_temp\fileListing.csv",
    Source = Csv.Document(
        File.Contents( CsvPath ),
        [Delimiter=",", Columns=3, Encoding=TextEncoding.Utf8, QuoteStyle=QuoteStyle.None]),
    #"Csv Typed" = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),    
    
    Source2 = Table.TransformColumnTypes(
        #"Csv Typed", {{"Name", type text}, {"LastWriteTime", type datetime}, {"FullName", type text}}),

    #"Find Files" = Table.AddColumn(
        Source2, "Files", 
        (row) => 
            let 
                bytes = File.Contents( row[FullName] ),
                Meta = Value.Metadata( bytes )
            in 
                [
                    ContentType = Meta[Content.Type],
                    FullName = row[FullName],
                    Bytes = bytes,
                    Meta = Meta
                ],
        type [
            ContentType = text, FullName = text, Bytes = binary, Meta = Record.Type            
        ]
    ),
    #"Expanded Files" = Table.ExpandRecordColumn(#"Find Files", "Files", {"ContentType", "Bytes", "Meta"}, {"ContentType", "Bytes", "Meta"})
in
    #"Expanded Files"
```
