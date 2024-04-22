    let
        // this loads the table from json, aka "enter-data"
        Source = Table.FromRows(Json.Document(Binary.Decompress(Binary.FromText("i45WcnRytgZiXQMDU+vw/KKUYiUdJUMghoopxepEw9ggdXA1RphqgCLGQIykxQSsHGScCVy5CVgeLA612BjFOGMk/UYoOo2UYmMB", BinaryEncoding.Base64), Compression.Deflate)), let _t = ((type nullable text) meta [Serialized.Text = true]) in type table [Tag = _t, Story = _t, Expected = _t]),
        #"Changed Type" = Table.TransformColumnTypes(Source,{{"Tag", type text}, {"Story", Int64.Type}, {"Expected", type text}}),

        Text.HasHyphen = (source as text) as logical =>
            Text.Contains(source, "-", Comparer.OrdinalIgnoreCase ),

        SplitStoryTags = (source as text ) => [
            Segments = Text.Split( source, ";"),
            Filtered = List.Select( Segments,
                (item) => Text.HasHyphen( item )
            ),
            Return =  List.First( Filtered, "" )
        ],

        Col_AddTags = Table.AddColumn( #"Changed Type" , "Result",
            (row) => SplitStoryTags( row[Tag] ) ,
            Record.Type ),

        Custom1 = Col_AddTags,
        #"Expanded Result" = Table.ExpandRecordColumn(Custom1,
            "Result",
            {"Return"}, {"Result.Return"} ),

        #"Added Custom" = Table.AddColumn(#"Expanded Result", "IsGood",
            each [Expected] = [Result.Return],
            Logical.Type )
    in
        #"Added Custom"