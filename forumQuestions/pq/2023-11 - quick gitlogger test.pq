let
    UrlRoot = {
        "http://127.0.0.1:7077",
        "https://gitloggerfunction.azurewebsites.net"
    }{1},
    /*
    report parameters:
     UrlRoot = {
        "http://127.0.0.1:7077",
        "https://gitloggerfunction.azurewebsites.net"
    }
    2023-11-08

    json grammar: https://www.json.org/json-en.html

    */
    // "Repository=https://github.com/StartAutomating/ugit&Property=GitUserName,RepositoryURL,GitUserName&MetricName=CommitCount&Year=2023&Month=01"

    xray = (source as any, optional options as nullable record) as text => [
            defaults = [ Verbose = true ],
            mergedOptions = Record.Combine(
                { defaults, (options ?? []) }
            ),
            bytes = Json.FromValue(source, TextEncoding.Utf8),

            str   = Text.FromBinary(bytes, TextEncoding.Utf8),
            verbose_str = Text.Replace( str, ",", ",#(cr,lf)    "),

            return =
                if (mergedOptions[Verbose]? ?? true) then verbose_str else str

                // if (options[Verbose]? ?? true) = true then verbose_str else str
        ][return],

    defaultOptions = [
        RelativePath = "Get-GitLogger",
        Query = defaultQuery
    ],
    defaultQuery = [
        Repository = "https://github.com/StartAutomating/ugit",
        Property = "GitUserName,RepositoryURL,GitUserName",
        MetricName = "CommitCount",
        Year = "2023",
        Month = "01"
    ],

    inputs = {
        [
            Label = "NetLineCadence: of GitLogger",
            RequestOptions = [ Query = Query, RelativePath = RelativePath ],
            RelativePath = "Get-GitLogger",
            OwnerName = "StartAutomating",
            RepoName = "GitLogger",
            Query = [
                Repository =
                    Text.Format(
                        "https://github.com/{0}/{1}",
                        { OwnerName, RepoName }
                    ),
                // Property = "GitUserName,RepositoryURL,GitUserName",
                MetricName = "NetLineCadence",
                Year = "2023",
                Month = "01"
            ]

            // Repository=https://github.com/StartAutomating/GitLogger&MetricName=NetLineCadence
        ],
        [
            Label = "User CommitCounts of ugit",
            RequestOptions = [
                Query = Query, RelativePath = RelativePath
            ],
            RelativePath = "Get-GitLogger",
            Query = [
                Repository = "https://github.com/StartAutomating/ugit",
                Property = "GitUserName,RepositoryURL,GitUserName",
                MetricName = "CommitCount",
                Year = "2023",
                Month = "01"
            ]
        ],
        [
            Label = "part 0",
            RequestOptions = [
                Query = Query, RelativePath = RelativePath
            ],
            RelativePath = "Get-GitLogger",
            Query = defaultQuery
        ],
        [
            Label = "basic",
            RequestOptions = defaultOptions,
            Query = defaultQuery
        ]
    },


    t_inputs = Table.FromRecords(
        inputs,
        type table [
            Label = text,
            RequestOptions = record,
            Query = record
        ], MissingField.Error

    ),

    t_expandParamInfo = Table.AddColumn(
        t_inputs,
        "ParamInfo",
        (row) as record => [
            ActivityId = Diagnostics.ActivityId(),
            Label   = row[Label],
            // Query_  = xray( row[Query], [Verbose = true] ),
            Query   = row[Query],
            Query_  = xray( Query ),
            RequestOptions = row[RequestOptions],
            RequestOptions_ = xray( RequestOptions )
        ], // ][[Query],[Query_]],
        type record
    ),
    // sugar
    Text.ContainsCI = (string as text, substring as text) as logical =>
        Text.Contains( string, substring, Comparer.OrdinalIgnoreCase ),
        // ( RawText, "<html>", Comparer.OrdinalIgnoreCase )

    // expand metadata for each request
    WebRequest = (source as any, optional requestOptions as nullable record, optional otherOptions as nullable record) as record => [
        DefaultEncoding = otherOptions[Encoding]? ?? TextEncoding.Utf8,
        Status = RequestMeta[Response.Status],
        Bytes =
            try
                Web.Contents( source, requestOptions )
            catch (e) =>
                error e meta [
                    ActivityId = Diagnostics.ActivityId(),
                    Source = "WebRquest"
                ],

        RequestMeta = Value.Metadata( Bytes ),
        Json = Json.Document( Bytes, DefaultEncoding ),
        Json_ = xray( Json ),
        IsJson =
            not (try Json)[HasError],
        IsHtml =
            Text.ContainsCI( RawText, "<html>" ),
        IsOther =
            not IsJson and not IsHtml,
        RawText = Text.FromBinary( Bytes, DefaultEncoding ),
        RequestUrl = RequestMeta[Content.Uri](),
        Headers_  = xray( RequestMeta[Headers] ),
        Request.Options_ = xray( RequestMeta[Request.Options] )
    ],
    t_response = Table.AddColumn(
        t_expandParamInfo,
        "Response",
        (row) => WebRequest(
            UrlRoot,
            row[ RequestOptions ]
            // row[OtherOptions]
        ),
        type record
    ),
    r_schema = type [
        Rows = any,
        RowCount = Int64.Type,
        Status = Text.Type,
        Url = Uri.Type
    ],
    r_schema_old = Record.Type,


    t_nestedData = Table.AddColumn(
        t_response,
        "NestedData",
        (row) => [
            Rows =
                Table.FromRecords( row[Response][Json], null, MissingField.Error ),
            RowCount =
                try Table.RowCount( Rows )
                catch (e) => null,

            Status = row[Response][Status],
            Url = row[Response][RequestUrl],



            HadErr =
                (try row[Response][Bytes])[HasError],
            BytesCount =
                Binary.Length( row[Response][Bytes] ),
            Summary =

                Text.Format(
                    "#[icon] #[status]: #[kind] ⇒ #[rowCount] rows ⁞ #[renderByteCount]", [
                        rowCount = RowCount,
                        // BytesCountKb = BytesCount / 1024,


                        renderByteCount =
                            Text.Format(
                                "#[Value] #[Unit]",
                                [
                                    Unit = "b",
                                    // Value = BytesCount / 1024
                                    Value =
                                        Number.ToText(
                                            BytesCount,
                                            // (BytesCount / 1024),
                                            "n0", Culture.Current )
                                ] ),


                        // byteCount =
                        //     Text.Format(
                        //         "#[sizeKb] kb",
                        //         [
                        //             sizeKb =
                        //                 Number.ToText(
                        //                     BytesCount / 1024,

                        //         ]
                        //     ),

                        icon =
                            if HadErr // this icon isn't working
                            then "❌"
                            else "✔️",
                        status =
                            try row[Response][Status]
                            catch (e) => "#(2400)",
                        kind =
                            try
                                if row[Response][IsJson] then "📄 json"
                                else if row[Response][IsHtml] then "🌐 html"
                                else if row[Response][IsOther] then "other"
                                else "unknown"
                            catch (e) =>
                                "#(2400)"
                    ],
                    Culture.Current
                )
        ],
        type [
            Rows = Table.Type,
            RowCount = Int64.Type,
            BytesCount = Int64.Type,
            Status = Text.Type,
            Url = Uri.Type,
            Summary = Text.Type,
            HadErr = Logical.Type
        ]
            // Table.FromList(
            //     row[Response][Json],
            //     Splitter.SplitByNothing(),
            //     null,
            //     null,
            //     ExtraValues.Error
            // ),
            // r_schema
        // Record.Type
    ),
    t_expandNested = if FinalConfig[AutoExpandNestedDataCols]? ?? true
        then
            let expanded =
                Table.ExpandRecordColumn(
                    t_nestedData,
                    "NestedData",
                    {"Rows", "RowCount",  "Status", "Url", "HadErr", "Summary"},
                    {"Rows", "RowCount",  "Status", "Url", "HadErr", "Summary"}
                )
                //, withSchema =
                //     Table.TransformColumnTypes(
                //         t_nestedData,
                //         {
                //             {"Rows", type any },
                //             {"Status", type number },
                //             {"Url", Uri.Type }
                //         }
                //     )
            in
                expanded

        else
            t_nestedData,

    // Table.ExpandRecordColumn(BaseQueriesList, "NestedData", {"Rows", "Status", "Url"}, {"NestedData.Rows", "NestedData.Status", "NestedData.Url"})
    t_orderCols =
        if
            not FinalConfig[AutoOrderCols]? ?? true
        then
            t_expandNested
        else
            Table.ReorderColumns(
                t_expandNested,
                {
                    "Summary",
                    "HadErr",
                    "Status",
                    "Label",
                    "RequestOptions",
                    "Query",
                    "ParamInfo",
                    "Response",
                    "Rows", "RowCount",
                    "Url"
                }
            ),



    FinalConfig = [
        ShowSummaryStep = false, // one step before
        AutoExpandNestedDataCols = true,
        AutoDrillDown = false,
        AutoOrderCols = true
    ]

in
    if FinalConfig[ShowSummaryStep]? ?? true
    then
        if FinalConfig[AutoDrillDown]? ?? false
        then t_response{1}[Response]
        else t_response
    else
        t_orderCols