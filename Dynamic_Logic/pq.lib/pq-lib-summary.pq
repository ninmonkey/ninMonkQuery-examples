[
    GroupBy.ShowCounts = (source as table, columnNames as list) as table => [
        columnNames = Columns.ThatExist(source, columnNames ),
        grouped = Table.Group( source, columnNames, {
            { "Distinct", each Table.RowCount( Table.Distinct( _, columnNames ) ), Int64.Type },
            { "Count",    each Table.RowCount(_), Int64.Type }
        }),
        ret = grouped
    ][ret],

    /* if columns are valid, return them
    otherwise give an error showing which columns were requested, and which are missing
    */
    Columns.ThatExist = (source as table, columnNames as list) as any => [
        source_columnNames = Table.ColumnNames(source),
        all_exist = List.ContainsAll( source_columnNames, columnNames, Comparer.Ordinal ),
        assert = all_exist,
        error_missingMandatory =
            Err.InvalidColumnNames( source, columnNames )
            meta [ NinAssertName = "Columns.ThatExist", Activity = Diagnostics.ActivityId() ],

        valid_data = columnNames,
        ret = if assert then valid_data else error error_missingMandatory
    ][ret],

    Err.InvalidColumnNames = (
        source as table, columnNames as list, optional options as nullable record) as record => [
            MissingColumns = List.RemoveItems( columnNames, Table.ColumnNames(source) ),
            err = [
                Reason = "InvalidColumnsException",
                Detail = "Exact column names did not match. Verify capitalization and whitespace",
                Message.Parameters = {
                    source,
                    FmtList( columnNames ),
                    FmtList( Table.ColumnNames(source) ),
                    FmtList( MissingColumns )
                },
                Message.Format = options[Message.Format]? ??
                    FmtNL({ "",
                            "RequiredParameterMissingValues ColumnNames: ",
                            "Table: #{0}",
                            "Wanted: ",
                            "    #{1}",
                            "Found: ",
                            "    #{2}",
                            "Missing: ",
                            "    #{3}"
                        })
                ]
            ][err],

    FmtList = Text.FormatList, // alias
    Text.FormatList = (source as list) as text => [
        Config = [
            BracePrefix = "{ ",
            BraceSuffix = " }",
            Separator = ", ",
            OuterSeparator = ""
        ],
        str_list = List.Transform( source, each Text.From(_) ),
        ret = Text.Combine( {
            Config[BracePrefix],
            Text.Combine( str_list, Config[Separator] ),
            Config[BraceSuffix]
        }, Config[OuterSeparator] )
    ][ret],

    // input:  type { any }
    // output: type { text }
    AsTextList = (source as any, optional culture as nullable text) as list => [
        ret = List.Transform( source, each Text.From(_, culture ?? null ))
    ][ret],

    // Join.Newline
    FmtNL = Text.JoinNewline, // alias
    Text.JoinNewline = (source as list) as text => [
        ret = Text.Combine( AsTextList( source ), Uni[CrLf] )
    ][ret],

    Uni = [
        CrLf        = "#(cr,lf)",
        Indent      = "    ",
        LineEnding  = CrLf,
        NL          = "#(lf)",
        Null        = "#(2400)",
        Monkey      = "#(0001F412)",
        SpaceSymbol = "#(2420)"
    ]

]