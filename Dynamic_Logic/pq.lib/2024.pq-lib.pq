[
    About = "ninlib 2024.01 | helper functions",
    ToCollect = {
        [ What = "Assert.ColumnsExist" ],
        [ What = "AssertConditions" ],
        [ What = "WebRequest.Wrapper", File = "H:\data\2023\BI\git\ninMonkQuery-examples\forumQuestions\pq\2023-11 - quick gitlogger test.pq" ]
        /*
        [1]
        / returns first+last merged, as one number
            Text.FindFirstLastDigits = ( source as text ) as number => [
                first = Text.PositionOfAny( source, digits, Occurrence.First ),
                last = Text.PositionOfAny( source, digits, Occurrence.Last ), chars = Text.ToList(source),
                textNumber = chars{first} & chars{last},
                return = Number.FromText( textNumber, null )
            ][return],
        [2]
            let
                    SketchBuffer = let
                    curFilename = "sketchbuffer.pq",
                    fullPath = Text.Combine({ #"Pq Folder", curFilename }, "\")
                in
                    EvalQuery( fullPath ),
                    q0000 = Table.FromRecords( SketchBuffer[q0000] )
                in
                    q0000
        [3]
            // EvalQuery
                let
                // evaluates a .pq text file that's editable outside of power bi, without pasting updates. just refresh.
                EvalQueryFunc = (filePath as text, optional options as nullable record) as any => [
                    encoding = options[Encoding]? ?? TextEncoding.Utf8,
                    environment = options[Environment]? ?? #shared,
                    bytes = File.Contents(filePath),
                    lines = Text.FromBinary( bytes, encoding ),
                    return = Expression.Evaluate( lines, environment )
                ][return]
            in
                EvalQueryFunc

            // EvalQuery
                    let
                    // evaluates a .pq text file that's editable outside of power bi, without pasting updates. just refresh.
                    EvalQueryFunc = (filePath as text, optional options as nullable record) as any => [
                        encoding = options[Encoding]? ?? TextEncoding.Utf8,
                        environment = options[Environment]? ?? #shared,
                        bytes = File.Contents(filePath),
                        lines = Text.FromBinary( bytes, encoding ),
                        return = Expression.Evaluate( lines, environment )
                    ][return]
                in
                    EvalQueryFunc

                // SharedUtils_Path
                "H:\data\2023\BI\git\ninMonkQuery-examples\Dynamic_Logic\AdventOfCode2023\pq\shared_utils.pq" meta [IsParameterQuery=true, List={"H:\data\2023\BI\git\ninMonkQuery-examples\Dynamic_Logic\AdventOfCode2023\pq\shared_utils.pq"}, DefaultValue="H:\data\2023\BI\git\ninMonkQuery-examples\Dynamic_Logic\AdventOfCode2023\pq\shared_utils.pq", Type="Text", IsParameterQueryRequired=true]

                // lib
                let
                    Source = EvalQuery( SharedUtils_Path )
                in
                    Source

        */
    },


    Csv = (source as list) as text => [
        segments = List.Transform( source, each Text.From(_) ),
        return = Text.Combine( segments, ", " )
    ][return],

    Uni = [
        CrLf = "#(cr,lf)",
        Indent = "    ",
        LineEnding = CrLf,
        NL = "#(lf)",
        Null = "#(2400)",
        Monkey = "#(0001F412)",
        SpaceSymbol = "#(2420)"
    ],
    /*
        in:  { "a", 2, #date(2023,1,4) },
        out: "{ a, 2, 2023-01-04 }"
    */
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
    FmtList = Text.FormatList,
    AsTextList = (source as any, optional culture as nullable text) as list => [
        ret = List.Transform( source, each Text.From(_, culture ?? null ))
    ][ret],
    /*
        in:  { "a", "b" }
        out: "a#(cr,lf)b"
    */
    FmtNL = (source as list) as text => [
        ret = Text.Combine( AsTextList( source ), Uni[CrLf] )
    ][ret],

   /* new error message */
    Err.InvalidColumns = Err.InvalidColumnNames, // this alias will probably be too general that it will collide or change
    Err.InvalidColumnNames = (source as table, columnNames as list, optional options as nullable record) as record => [
        // or table source could be name,
        // assert = if sourceOrName is table then
        //     Columns.ThatExist( sourceOrName, columnNames )
        // else
        //     true,
        // assertAllowedKeys = {"Reason", "Detail", "Message.Parameters", "Message.Format" },
        // tableName = if source is text then source else Expression.Identifier(source),
        MissingColumns = List.RemoveItems( columnNames, Table.ColumnNames(source) ),
        err = [
            Reason = options[Reason]? ?? options[ExceptionName]? ??
                "InvalidColumnsException",
            Detail = options[Detail]? ??
                "Exact column names did not match. Verify capitalization and whitespace",
            Message.Parameters = {
                source, // AsText?
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
    /*
    Asserts if columns are valid, return their names as a list
    otherwise throw

        in:  { "Name", "Id" }
        out: good
            { "Name", "Id"}
        out: bad
            error Exception for missing columns
    */
    Columns.ThatExist = (source as table, columnNames as list) as any => [
        src_colNames = Table.ColumnNames(source),
        all_exist = List.ContainsAll( src_colNames, columnNames, Comparer.Ordinal ),
        assert = all_exist,
        error_missingMandatory =
            Err.InvalidColumnNames( source, columnNames )
            meta [ NinAssertName = "Columns.ThatExist", Activity = Diagnostics.ActivityId() ],

        valid_data = columnNames,
        ret = if assert then valid_data else error error_missingMandatory
    ][ret],

    //   distinct_per_pair = Table.Group(Source, {"Species", "Region"}, {{"Distinct", each Table.RowCount(Table.Distinct(_, {"Species", "Region"})), Int64.Type}, {"Count", each Table.RowCount(_), Int64.Type}})

    GroupBy.ShowCounts = (source as table, columnNames as list) as table => [
        columnNames = Columns.ThatExist(source, columnNames ),
        grouped = Table.Group( source, columnNames, {
            { "Distinct", each Table.RowCount( Table.Distinct( _, columnNames ) ), Int64.Type },
            { "Count", each Table.RowCount(_), Int64.Type }
        }),
        ret = grouped
    ][ret],

        // columnsThatExist = [
        //     src_colNames = Table.ColumnNames(source),
        //     all_exist = List.ContainsAll( src_colNames, columnNames, Comparer.Ordinal ),
        //     assert = all_exist,
        //     // error_missingMandatory = error "Stuff",
        //     error_missingMandatory = error [
        //         Reason = "MissingColumns",
        //         Details = "dsf",
        //         Detail = "Exact match for columns was not found. Check if capitalization or whitespace is different",
        //         Message.Format = "RequiredParameterMissingValues ColumnNames: #(cr,lf)Wanted: #(cr,lf)    #{0}, #(cr,lf)Found: #(cr,lf)    #{1}",
        //         // Message.Parameters = [ want = "a", act = "b" ]
        //         // Message.Parameters = { "a", "b" }
        //         Message.Parameters = { FmtList(columnNames), FmtList(src_colNames) }
        //         // Message.Parameters = [ WantedColumns = Text.Combine(columnNames, ", "), FoundColumns = Text.Combine(src_colNames, ", ") ]
        //     ],
        //     final_data = columnNames,
        //     ret = if assert then final_data else error error_missingMandatory
        // ][ret],
    // converts a nulls and empty strings to printable values
    /*
        in:  { "a", "", null, 4 }
        out: { "a", "<EmptyStr>", "␀", 4 }
    */
    FmtShowEmpty = (source as list) as list => [
        ret = List.ReplaceMatchingItems( source,
            {   { "", "<EmptyStr>" },
                { null, Uni[Null]  } }
        )
    ][ret],

    ray = XRay,
    XRay = (source as any) as text => [
        // see also: Xray, ToJson, Csv
        bytes = Json.FromValue( source, TextEncoding.Utf8 ),
        json = Text.FromBinary( bytes, TextEncoding.Utf8 )
    ][json],

    ToJson = (source as any, optional options as nullable record ) as text => [

        // see also: Xray, ToJson, Csv
        defaults = [
            Encoding = TextEncoding.Utf8,
            Expand = true
        ],
        config = Record.Combine({
            options ?? [],
            defaults
        }),
        json = Text.FromBinary( Json.FromValue( source, config[Encoding] ) , config[Encoding] ),
        json_expanded = Text.Replace( json, "},{", "},#(cr,lf){"),
        return = if config[Expand] then json_expanded else json
    ][return],

    // Like Text.Replace except that this replaces at most one single occurrence of oldValue
    Text.ReplaceFirstOnly = (source as nullable text, oldValue as text, newValue as text) as nullable text => [
        found = Text.PositionOf( source, oldValue, Occurrence.First, Comparer.OrdinalIgnoreCase ),
        replaced = Text.ReplaceRange( source, found, Text.Length( oldValue ), newValue ),
        return =
            if source = null then null
            else if found = -1 then source
            else replaced
    ][return],

    Text.Contains.CI = (source as text, substring as text) as logical =>
        // see also: Text.Contains.CI, Text.PositionOf.CI, Text.MatchesAnyOf.CI
        Text.Contains( source, substring, Comparer.OrdinalIgnoreCase ),

    Text.PositionOf.CI = (source as text, substring as text, optional options as nullable record) as any => [
        // see also: Text.Contains.CI, Text.PositionOf.CI, Text.MatchesAnyOf.CI
            occurrence = options[Occurrence]? ?? Occurrence.First,
            comparer = options[Comparer]? ?? Comparer.OrdinalIgnoreCase,
            ret = Text.PositionOf( source, substring, occurrence, comparer )
        ][ret],

    Text.MatchesAnyOf.CI = (sourceList as text, patternList as list) as logical => [
        // see also: Text.Contains.CI, Text.PositionOf.CI, Text.MatchesAnyOf.CI
        // todo: validate, add tests
        ret = List.Select(
            sourceList,
            (source) => List.AnyTrue(
                List.Transform( patternList, (pattern) => Text.Contains.CI( source, pattern ) )
            )
        )
            // List.Contains( patternList, item, Comparer.OrdinalIgnoreCase ))


        // ret = List.Select( sourceList, (item) =>
            // List.Select(
            //     sourceList, (item) =>
            //         List.AnyTrue(
            //             List.Transform(
            //                 patternList,
            //                 (pattern) => Text.Contains( item, pattern, Comparer.OrdinalIgnoreCase ) ) ) ).AnyTrue( List.Transform( patternList, )

    ][ret],

    Table.UntypedColumns = (source as table) as any => [ //  table => [
        Source = source,
        ColumnsFromTableSchema = Table.Schema(source),
        ret = error "NYI"
    ][ret],


    Assert.ColumnsExist = (source as table, requiredNames as list) as any => [ // as logical => [
        // refacot and export this func to shared
        config = [
            // DetailedOutput = true,
            // CaseSensitiveCompare = true
            // CultureComparer = null
        ],
        // details = [

        // ],
        actualCols  = List.Buffer( Table.ColumnNames( source ) ),
        missingCols = List.RemoveItems( requiredNames, actualCols ),
        extraCols   = List.RemoveItems( actualCols, requiredNames ),

        conditionsUsingSchema = [
                Source = Table.Schema( source ),
                #"Sorted Rows" = Table.Sort(Source,{{"TypeName", Order.Ascending}}),
                #"Filtered Rows" = Table.SelectRows(#"Sorted Rows", each ([Kind] = "any"))
            ],


        shouldThrow = List.Count( missingCols ) > 0, // todo: future: make names case insensitive using config
        FinalAssertStatement =
            if not shouldThrow then true else error [
                Message.Format = Text.Combine({
                    "Assert: ColumnsExist failed! Target: #[Source], To find: #[ToFind]",
                    "ActualCols: #[ActualCols]",
                    "MissingCols: #[MissingCols]",
                    "ExtraCols: #[ExtraCols]"
                }, "#(cr,lf)"),
                Message.Parameters = [
                    ToFind = requiredNames,
                    Source = source,
                    ActualCols = actualCols,
                    MissingCols = missingCols,
                    ExtraCols = extraCols
                ] ],
        // return = FinalAssertStatement,
        return = error "WIP"
            // if config[DetailedOutput] then details
            // else FinalAssertStatement
            // error "NYI, successfull stand alone bool"
        // Table.SelectColumns( Source, ExpectCols, MissingField.Error ),
        // finalCondCondition =
        //     try a catch (e) =>
        //     error e
        ][return],

    Assert.ColumnsHaveTypes = (source as table) as any => [
        /*
        three potential test kinds
            [3] primitveType == any
            [3] longType == any
            [3] Value.Type( data ) is type any
        */
        ret = error "NYI"
        // .IsNotTypeAny
    ][ret],
//     let
//     Source = List.Select( Record.FieldNames( #shared ), (item) => List.AnyTrue( List.Transform( {"Path", "Folder", "Dir", "File"}, (pattern) => Text.Contains( item, pattern, Comparer.OrdinalIgnoreCase ) ) ) )
// in
//     Source
    Convert.ScriptExtent = (err as any) => [
        /* todo:example
            /// import
            Source = EvalQuery( SharedUtils_Path ),
            ext = convertScriptExtent( (try err catch (e) => e) ),

            converts an error from:
                [117,5-117,17] Token ',' expected.

            to line numbers as a record
        */
            Split.ScriptExtent = Splitter.SplitTextByEachDelimiter({"[", ",", "-", ",", "]"}, QuoteStyle.None),
            lineData = Split.ScriptExtent( err[Message] ),
            ret = [
                StartLineNumber   = Number.FromText( lineData{1}? ),
                StartColumnNumber = Number.FromText( lineData{2}? ),
                EndLineNumber     = Number.FromText( lineData{3}? ),
                EndColumnNumber   = Number.FromText( lineData{4}? ),
                RemainingMessage  = lineData{5}?,                      // shouldn't be more than 1 index?
                Reason            = err[Reason],
                Message           = err[Message],
                ErrorRecord       = err,
                RawText           = err[Message]
            ] meta [ NinTypeName = "ScriptExtent"]
        ],

    File.ShowError = ( path as text, extent as record) => [
        // display lines involved in the error
        path = path ?? "H:\data\2023\BI\git\ninMonkQuery-examples\Dynamic_Logic\pq.lib\2024.pq-lib.pq",
        contents = Lines.FromBinary( File.Contents( path ), QuoteStyle.None, false, TextEncoding.Utf8 ),
        linesCount =  extent[EndLineNumber] - extent[StartLineNumber],
        selectedLines = List.Range( contents, extent[StartLineNumber] - 2, linesCount + 2 ),
        prefix =  {
            "Reason: #[Reason]#",
            "#Message: #[Message]#",
            "..."
        },
        merged = Text.Combine( prefix & selectedLines, "#(cr,lf)" ),
        ret = Text.Format( merged, [
            Reason = extent[Reason],
            Message = extent[Message]
        ] )
    ][ret],


    Template.Nin = ( optional basePath as nullable text, optional options as nullable record) as any => [
        // links to files as an easy import
        root = basePath ?? "H:\datasource\nin.🐒.template",
        allFiles = Folder.Contents( root ),
        ret = if options[PathOnly]? ?? false then root else allFiles
    ][ret]
]