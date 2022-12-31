// Answer
let
    Source = Table.FromRows(Json.Document(Binary.Decompress(Binary.FromText("i45W8klMSs2J9yvNVdJRCkvMKU2FsiHibqmpRnAJMCc2FgA=", BinaryEncoding.Base64), Compression.Deflate)), let _t = ((type nullable text) meta [Serialized.Text = true]) in type table [Label_Proj = _t, Value_Proj = _t, Label_Fee1 = _t, Value_Fee1 = _t]),
    #"Added Index" = Table.AddIndexColumn(Source, "Index", 0, 1, Int64.Type),
    #"Unpivoted Other Columns" = Table.UnpivotOtherColumns(#"Added Index", {"Index"}, "L", "R"),
    table_as_pairs = Table.Split(  #"Unpivoted Other Columns", 2 ),

    process_tablePair = (source as table) as record =>
        // quick sketch as a test
        [
            l_pair = source[L],
            r_pair = source[R],
            rec1 = Record.AddField( [],   l_pair{0}, l_pair{1} ),
            all  = Record.AddField( rec1, r_pair{0}, r_pair{1} )
        ][all],

    #"apply tablePairs" = List.Transform(
        table_as_pairs ,
        (cur_table) as record =>
            process_tablePair( cur_table ) ),

    final_value = Record.Combine( #"apply tablePairs" ),

    /* extra stuff */
    maybeEqual =    expected_value = final_value,
    expected_value = [
        Label_Proj = "Value_Proj",
        Label_Num  = "Value_Num",
        Label_Fee1 = "Value_Fee1",
        Label_Fee2 = "Value_Fee2"
    ],
    Summary = [ 
        #"Test: Expected Value?" = expected_value = final_value,
        expected_value = expected_value,
        final_value = final_value,
        fn_func = process_tablePair,
        oneTarget = table_as_pairs{0},
        apply_oneTarget = process_tablePair( oneTarget )
    ],
    final_result = // automatically show extra info when test fails
        if expected_value = final_value
        then final_value else Summary
in
    final_result