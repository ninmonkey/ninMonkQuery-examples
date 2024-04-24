// DevicesOU_MultiRow
let
    EnterData = Table.FromRows(Json.Document(Binary.Decompress(Binary.FromText("i45Wckkty0xONbRSqKis0ssvSo+JgYgUK8Xq4JGNiQkoyk8hRk1MjH9aGpCLpNYIU60CWFoBwjPG6xosshiuMcFrAhbZmJiQ1OISoCtiAQ==", BinaryEncoding.Base64), Compression.Deflate)), let _t = ((type nullable text) meta [Serialized.Text = true]) in type table [Text = _t]),
    Source = Table.TransformColumnTypes(EnterData,{{"Text", type text}}),

    #"Added Custom" = Table.AddColumn(Source, 
        "SplitToRecords",         
        (row) => [
            Segments = Text.Split( row[Text], ": "),
            DeviceName = Segments{0},
            OU = Segments{1}
        ], Record.Type
    ),
    // returns a single item, the longest string
    List.SelectLongest = (source as list) as any => 
        List.First( List.SortByLongest( source ) ),

    // returns original list, sorted as longest first 
    List.SortByLongest = (source as list) as list => 
        List.Sort( source, (item) => -Text.Length( item ) ),


    #"Expanded SplitToRecords" = Table.ExpandRecordColumn(#"Added Custom", "SplitToRecords", {"DeviceName", "OU"}, {"Device", "OU"}),
    #"Changed Type" = Table.TransformColumnTypes(#"Expanded SplitToRecords",{{"Device", type text}, {"OU", type text}}),
    #"Cleaned Text" = Table.TransformColumns(#"Changed Type",{ {"Device", Text.Trim, type text}, {"OU", Text.Trim, type text}} ),
    #"Removed Other Columns" = Table.SelectColumns(#"Cleaned Text",{"Device", "OU"}),
    #"Grouped Rows" =  Table.Group(
            #"Removed Other Columns", {"Device"},
            { 
                {
                    "OU_Longest",
                    (row) => List.SelectLongest( row[OU] ), 
                    Text.Type
                } 
            }
            
        )
in
    #"Grouped Rows"

// DevicesOU_SingleLine
let
    
    EnterData = Table.FromRows(Json.Document(Binary.Decompress(Binary.FromText("i45Wckkty0xONbRSqKis0ssvSo+JgYgUW6MLxMQEFOWn4BCOifFPSwNylWJ1YGYaYZqpgCRtTLSVSJpMiNIUklpcArQqFgA=", BinaryEncoding.Base64), Compression.Deflate)), let _t = ((type nullable text) meta [Serialized.Text = true]) in type table [Text = _t]),
    Source = Table.TransformColumnTypes(EnterData,{{"Text", type text}}),

    // this is overkill. I kept it verbose so you can inspect each stage 
    // it splits a single line, multiple times, as a single "step"
    SplitToRecords = Table.AddColumn(Source, 
        "SplitToRecords",         
        (row) => [
            // Segments = Text.Split( row[Text], ": "),
            line        = row[Text],
            DeviceName  = Text.BeforeDelimiter( line, ": ", 0 ),
            RestOfLine  = Text.AfterDelimiter( line, ": ", 0 ),
            OU_list     = Text.Split( RestOfLine, ";"),
            sortByLongest = List.Sort( OU_list, each -Text.Length(_) ),
            OU_Longest    = List.First( sortByLongest, null )
        ], Record.Type
    ),
    
    // for testing, this lets you see one record at a time
    InspectOneRow = SplitToRecords{0}[SplitToRecords],

    // else grab the only two columns that we care about
    #"Expanded SplitToRecords" = Table.ExpandRecordColumn(
        SplitToRecords, "SplitToRecords", 
        {"DeviceName", "OU_Longest"}, {"DeviceName", "OU_Longest"} ),

    #"Changed Type" = Table.TransformColumnTypes(
        #"Expanded SplitToRecords",
        { {"DeviceName", type text}, {"OU_Longest", type text}} )
in
    #"Changed Type"
