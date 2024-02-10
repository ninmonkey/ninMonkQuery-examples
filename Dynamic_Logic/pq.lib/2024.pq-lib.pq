let r = [
    About = "ninlib 2024.01 | helper functions",
    ToCollect = {
        [ What = "Assert.ColumnsExist" ],
        [ What = "AssertConditions" ],
        [ What = "WebRequest.Wrapper", File = "H:\data\2023\BI\git\ninMonkQuery-examples\forumQuestions\pq\2023-11 - quick gitlogger test.pq" ],
        [ What = "Inspirations", Url = "https://github.com/acaprojects/m-tools/tree/master/src" ]
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

    // aggressive aliases?
    Csv = Text.FormatCsv,
        Format.Csv = Csv,
        Fmt.Csv = Csv,

    Text.FormatCsv = (source as list) as text => [
        segments = List.Transform( source, each Text.From(_) ),
        return = Text.Combine( segments, ", " )
    ][return] meta [ MetaNote = "AfterFuncReturn" ],

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
    FmtList = Text.FormatList meta [ AliasTo = "Text.FormatList", NinLibType = "Alias" ],
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
        },  Config[OuterSeparator] )
    ][ret],

    /*
        AsList.Text = AsTextList,
        AsList.OfText = TextList = AsTextList,
        To.TextList = Transform.TextList,
        AsTextList = As.TextList,
        To.TextList = As.TextList,
    */

    // # attributes could auto-strip these out based on a config value, that reads metadata
    ListOf.Text        = TransformTo.TextList,
        As.TextList        = ListOf.Text,
        // AsTextList         = ListOf.Text,
        // To.TextList        = ListOf.Text,
        // ToList.OfText      = ListOf.Text,
        AsList.OfText      = ListOf.Text,
        TextList           = ListOf.Text,
        Transform.TextList = ListOf.Text,
        // AsList.Text        = ListOf.Text,

    TransformTo.TextList = (source as any, optional culture as nullable text) as list => [
        ret = List.Transform( source, each Text.From(_, culture ?? null ))
    ][ret],
    /*
        in:  { "a", "b" }
        out: "a#(cr,lf)b"
    */
    Join.NewLine = Format.JoinNewLine,
        Join.NL = Join.NewLine,
        FmtNL   = Join.NewLine,

    Format.JoinNewLine = (source as list) as text => [
        ret = Text.Combine( As.TextList( source ), Uni[CrLf] )
    ][ret],

    Format.JoinDocNewline = Format.JoinBR,
    Format.JoinBR = (source as list) as text => [
        ret = Text.Combine( As.TextList( source ), "#(cr,lf)<br>" )
    ][ret],



    // Input : list of all values.
    // Output: true emptyString, and nulls are replaced with control char symbols
    // roughly the first 0x1b codepoints, just add 0x2400 for safe to print
    /*
        in:  { "a", "b" }
        out: "a#(cr,lf)b"
    */
    Format.ControlChar = Format.ShowBlank,
        Fcc            = Format.ShowBlank,
        Format.Newline = Format.ShowBlank,
        Format.Blank = Format.ShowBlank,

    Format.ShowBlank = (source as list) as list => [
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






    // values like "10s" or "3m"
    Splitter.SplitDigitWithSuffix = // Splitter.SplitTextByDigitWithSuffixTransition =
        Splitter.SplitTextByCharacterTransition(
        {"0".."9"}, (c) => not List.Contains({"0".."9"}, c) ),

    Doc.Expand = Format.DocExpand,
    /*
     sugar to make it easier to embed powerquery as a string literal

        It replaces '␞' with double quotes '"'

        input : List.SelectBySuffix( { {␞2␞, ␞d␞}, {␞3␞, ␞h␞} }, ␞h␞)
        output: List.SelectBySuffix( { {"2", "d"}, {"3", "h"} }, "h")
    */
    Format.DocExpand = let
        Format.DocExpand.Type =
                type function ( source as text ) as text meta [
                    Documentation.Name = "Format.DocExpand",
                    Documentation.LongDescription = Format.JoinBR({
                        "A helper function to generate help strings without crazy escaping.",
                        "",
                        "Input:",
                        "",
                        "<code> = DocExpand( ""List.SelectBySuffix( { {␞2␞, ␞d␞}, {␞3␞, ␞h␞} }, ␞h␞)"" )</code>",
                        "",
                        "Output:",
                        "",
                        "<code> = 'List.SelectBySuffix( { {""2"", ""d""}, {""3"", ""h""} }, ""h"")""'</code>",
                        "",
                        "returns type <code>text</code>"
                            })
                ],
            Format.DocExpand.Func = (source as text) as text =>
                Text.Replace( source, "␞", "#(0022)" )
        in
            Value.ReplaceType( Format.DocExpand.Func, Format.DocExpand.Type ),


    Duration.FromCustom = let
        Duration.FromCustom.Type = type function (
            source as duration
        ) as duration meta [
            Documentation.Name = "Duration.FromCustom",
            Documentation.LongDescription = Text.Combine({
                "Call <code>Splitter.SplitDigitWithSuffix()</code>.","",
                "Pick out pairs of 'd', 'h', 'm', 's' and 'd' using <code>List.SelectBySuffix()</code>",
                "returns type <code>duration</code>"
            }, "<br>")
        ],

        Duration.FromCustom.Func = (source as text) as duration => [
            clean = Text.Trim( Text.Lower( source, Culture.Current ) ),
            s_segs = Text.Split(clean, " "),
            s_pairs = List.Transform( s_segs, (pair) => Splitter.SplitDigitWithSuffix( pair )),

            Days =
                Number.From( List.SelectBySuffix( s_pairs, "d" ) ) ?? 0,
            Hours =
                Number.From( List.SelectBySuffix( s_pairs, "h" ) ) ?? 0,
            Minutes =
                Number.From( List.SelectBySuffix( s_pairs, "m" ) ) ?? 0,
            Seconds =
                Number.From( List.SelectBySuffix( s_pairs, "s" ) ) ?? 0,

            inst =
                #duration( Days, Hours, Minutes, Seconds )
        ][inst]
    in
        Value.ReplaceType( Duration.FromCustom.Func, Duration.FromCustom.Type),
    // Duration.FromCustom = Value.ReplaceType( Duration.FromCustom.Func, Duration.FromCustom.Type),


    // expects a list of pairs of 2 elements, first is the digit, 2nd is the unit
    List.SelectBySuffix = let
        List.SelectBySuffix.Func = ( items as list, unit as text ) as any =>
            List.First(
                List.Select( items,
                    (i) => i{1} = unit ), null ){0}?,

        List.SelectBySuffix.Type = type function (
            items as (type { text }),
            unit as text
        ) as text meta [
            Documentation.Name = "List.SelectBySuffix",
            Documentation.LongDescription = Text.Combine({
                "After calling <code>Splitter.SplitDigitWithSuffix()</code>, this function will choose one item from the pair", "", "#(tab)<b>Example</b>:  For the text <code>'2m 3s'</code> find <code>'2'<code> if unit is <code>'m'<code>"
            }, "<br>"),
            Documentation.Examples = {
                [
                    Description = "Selects the first item in a list that ends with the specified suffix",
                    Code = Format.DocExpand( "List.SelectBySuffix( { {␞2␞, ␞d␞}, {␞3␞, ␞h␞} }, ␞h␞)" ),
                    Result = Format.DocExpand("3")
                ],
                [
                    Description = "Selects the first item in a list that ends with the specified suffix",
                    Code = Format.DocExpand( "List.SelectBySuffix( { {␞2␞, ␞d␞}, {␞3␞, ␞h␞} }, ␞d␞)" ),
                    Result = Format.DocExpand("2")
                ]
            }
        ]
    in
        Value.ReplaceType( List.SelectBySuffix.Func, List.SelectBySuffix.Type ),

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

        ninassert
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

    // return integer within the bounds of a list
    Random.IndexOf = (source as list) as number => [
        maxIndex = List.Count(source) - 1,
        return = Random.Int64(0, maxIndex)
    ][return],

    // FieldSectionNamesOnly =
    //     try List.Sort( Record.FieldNames( lib ) )
    //     catch (e) => { "Error", "Generating", "Completions" }, // , e[Message] },
    // InvokeIt = [
    //     // InvokeIt.Type = type function (
    //     //     funcName as (type text meta [
    //     //         Documentation.FieldCaption = "Function Name",
    //     //         Documentation.FieldDescription = "Name of the function to call",
    //     //         Documentation.SampleValues = {"Text.Format", "List.Transform"}
    //     //     ]),
    //     // ),
    //     Invoke.Nin.Type = type function (
    //         source as (type text meta [
    //             // Documentation.AllowedValues = {"foo", "bar"}
    //             Documentation.AllowedValues = FieldSectionNamesOnly
    //         ] )
    //     ) as any meta [
    //                 Documentation.Name = "Invoke.Nin",
    //                 Documentation.LongDescription = Format.JoinBR({
    //                     "Autocomplete all func names, itself?",
    //                     "Does stuff, returns type <code>text</code>"
    //                         })
    //             ],
    //     Invoke.Nin.Func = (source as text) as any =>
    //         source,

    //     return = Value.ReplaceType(Invoke.Nin.Func, Invoke.Nin.Type)
    // ][return],

    Random.Int = Random.Int64,
    Random.Int64 = [
        /*
            Source: https://github.com/ninmonkey/Ninmonkey.PowerQueryLib
            About: Randomized Int. [2021-04-22]
            See Also: Number.Round* family of functions, and <https://docs.microsoft.com/en-us/power-query/handlingdocumentation>
        */
        Random.Int.Type = type function (
            min as (type number meta [
                Documentation.FieldCaption = "Min",
                Documentation.FieldDescription = "Minimum number",
                Documentation.SampleValues = {10, 0.45}
            ]),
            b as (type number meta [
                Documentation.FieldCaption = "Max",
                Documentation.FieldDescription = "Maximum number",
                Documentation.SampleValues = {34, 100.45}
            ]),
            optional culture as (type nullable text meta [
                Documentation.FieldCaption = "Culture",
                Documentation.FieldDescription = "Culture used to convert number"
            ]),
            optional roundingMode as (type nullable number meta [
                Documentation.FieldCaption = "Rounding Mode",
                Documentation.FieldDescription = "rounding method",
                Documentation.AllowedValues = {
                    RoundingMode.AwayFromZero, RoundingMode.Down, RoundingMode.ToEven, RoundingMode.TowardZero, RoundingMode.Up}
            ])
        ) as table meta [
                Documentation.Name = "RandomInt",
                Documentation.LongDescription = "Generate a random Int64.Type between two values. Min and Max are Inclusive. Optionally set culture and rounding mode.",
                Documentation.Examples = {[
                    Description = "Generate one value",
                    Code = "RandomInt(10, 20)",
                    Result = "11"
                ]}
            ],

            Random.Int.Impl = (
            min as number,
            max as number,
            optional culture as nullable text,
            optional roundingMode as nullable number
        ) as number =>
            Int64.From(
                Number.RandomBetween( min, max ),
                culture,
                roundingMode
            ),
        return = Value.ReplaceType( Random.Int.Impl, Random.Int.Type )
    ][return],

    Random.Color = (optional options as nullable record) as text => [
        count = options[Count]? ?? 1,
        // sel = List.Random(0, )
        ret = "NYI"
    ][ret],
    Constant.Colors = [
        Red     = "#FF0000",
        Green   = "#00FF00",
        Blue    = "#0000FF",
        Yellow  = "#FFFF00",
        Cyan    = "#00FFFF",
        Magenta = "#FF00FF",
        White   = "#FFFFFF",
        Black   = "#000000"
    ],

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
                RemainingMessage  = lineData{5}?, // normally should be blank
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
            Reason  = extent[Reason],
            Message = extent[Message]
        ] )
    ][ret],


    Template.Nin = ( optional basePath as nullable text, optional options as nullable record) as any => [
        // links to files as an easy import
        root = basePath ?? "H:\datasource\nin.🐒.template",
        allFiles = Folder.Contents( root ),
        ret = if options[PathOnly]? ?? false then root else allFiles
    ][ret]
] in r