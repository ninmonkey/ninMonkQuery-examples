// WebRequest
let
    urlRoot = "https://httpbin.org",
    Uni = [
        NullSymbol = "#(2400)",
        Space = "␠"
    ],
    default_webRequestOptions = [
        ManualStatusHandling = List.Combine( {
            { 500..515 },
            { 200..299},
            // { 301..399 },
            { 400, 402 },
            { 404..500 }
            })
        ],
    // curl -X GET "https://httpbin.org/anything" -H  "accept: application/json"
    response = Web.Contents( urlRoot, [] ),

    // fancy web request with metadata, etc
    WebRequest = ( url as nullable text, optional options as nullable record, optional encoding as nullable number ) =>
        // url as text,
        let
            encoding = encoding ?? TextEncoding.Utf8,
            options = Record.Combine({
                default_webRequestOptions,
                (options ?? [])
            }),
            url = url ?? urlRoot,
            AsJson = Json.Document(bytes, encoding ),
            AsText = Text.FromBinary( bytes, encoding ),
            Json.HasError = ( try AsJson )[HasError],
            AsHtml =
                    if Json.HasError = false
                    then ""
                    else try Html.Table( bytes )
                         catch (e) => e[Message],

            info = Value.Metadata( bytes ),
            log_message = Jsonify(messageArgs),
            messageArgs = [
                Name = "Invoke-RestMethodBat",
                url = url,
                options = options
            ],

            bytes = Diagnostics.Trace(
                    TraceLevel.Error, log_message,
                    () =>  Web.Contents( urlRoot, options),
                    true
                ),

            selectKeys = options[selectKeys]? ?? {
                // "baseUrl",
                // "Info",
                // "Json.HasError",
                // "AsJson",
                // "AsText",
                // "AsHtml",
                // "ActivityId",
                // "ActivityId",
                //
                "baseUrl",
                "AsJson",
                "AsHtml",
                "AsText",
                "Uri",
                "Content.Type",
                "Content.Name",
                "Headers",
                "Json.HasError",
                "Request.Options",
                "StatusCode",
                "Info"
            },
            filter = Record.SelectFields( summary, selectKeys, MissingField.Error ),
            summary = [
                // bytes = bytes,
                baseUrl = url,
                StatusCode = info[Response.Status],
                Uri = info[Content.Uri](),
                Headers = info[Headers]? ?? null,
                Request.Options = info[Request.Options] ?? null,
                Content.Name = info[Content.Name],
                Content.Type = info[Content.Type],
                AsJson = AsJson,
                AsText = AsText,
                Json.HasError = Json.HasError,
                AsHtml = AsHtml,
                Info = info,
                ActivityId = Diagnostics.ActivityId()
            ]
        in

            filter,

    // Convert to Json, then decode as a string. sometime useful because the UI auto decodes
    Jsonify = (source as any, optional options as nullable record) as text => let
        encoding = options[encoding]? ?? TextEncoding.Utf8,
        messageArgs = source,
        bytes = Json.FromValue( messageArgs, encoding ),
        render = Text.FromBinary( bytes, encoding)
    in render,

    InspectResponse = ( source as record ) as record =>
        let
            x =  source,
            // t0 = Table.AddColumn(source, "Status Code", (row) => )
            final = x

        in final,

    Summary = {
        WebRequest(
            urlRoot, [
                RelativePath = "anything",
                Query = [ User = "nin", Species = "#(0001f412)" ]
            ]
        ),
        WebRequest(
            urlRoot, [
                RelativePath = "anything2432",
                Query = [ User = "Jen", Species = "#(0001f98e)" ]
            ]
        )
    },
    SummaryTable = Table.FromRecords( Summary, null, MissingField.Error ),

    // detect whether something is json
    first = Table.AddColumn(
        SummaryTable, "InspectResponse",
        (row) => InspectResponse( row )
    ),
    #"Expanded JsonErrors" = first,
    Table.AutoExpandRecordColumn = ( source as table, columnName as text ) => [
        sample = source{0}?[InspectResponse]?,
        someNames = Record.FieldNames( sample ),
        newNames = List.Transform( someNames, (i) => Text.From( columnName ) & "." & i),
        explode = Table.ExpandRecordColumn( source, columnName, someNames, newNames )
    // ][explode]
    ][explode],

// Table.ExpandRecordColumn(first, "JsonErrors", {"baseUrl", "Info", "Json.HasError", "AsJson", "AsText", "AsHtml", "ActivityId"}, {"JsonErrors.baseUrl", "JsonErrors.Info", "JsonErrors.Json.HasError", "JsonErrors.AsJson", "JsonErrors.AsText", "JsonErrors.AsHtml", "JsonErrors.ActivityId"})

    // Custom1 = Jsonify( [a =  "100", b = {0..3} ] )


    #"left off" = "
        - [ ] return record type for table expansion on web request
        - [ ] use VSCode -> logging info
    ",

    expand = false,
    x = if expand
        then Table.AutoExpandRecordColumn( first, "InspectResponse" )
        else first

    // Table.ExpandRecordColumn(first, "JsonErrors", {"baseUrl", "Info", "Json.HasError", "AsJson", "AsText", "AsHtml", "ActivityId"}, {"JsonErrors.baseUrl", "JsonErrors.Info", "JsonErrors.Json.HasError", "JsonErrors.AsJson", "JsonErrors.AsText", "JsonErrors.AsHtml", "JsonErrors.ActivityId"})
    // Custom1 = Jsonify( [a =  "100", b = {0..3} ] )
    // #"InspectResponse Info" = x{1}[InspectResponse.Info]


in
    x

// WebRequest-WithDebugInfo
let
    urlRoot = "https://httpbin.org",
    Uni = [
        NullSymbol = "#(2400)",
        Space = "␠"
    ],
    default_webRequestOptions = [
        // RelativePath = "...",
        // Headers = [],
        ManualStatusHandling = List.Combine( {
            { 500..515 },
            { 200..299},
            // { 301..399 },
            { 400, 402 },
            { 404..500 }
            })
        ],
    // fancy web request with metadata, etc
    WebRequest.DebugInfo = ( url as nullable text, optional options as nullable record, optional encoding as nullable number ) =>
        // url as text,
        let
            encoding = encoding ?? TextEncoding.Utf8,
            options = Record.Combine({
                default_webRequestOptions,
                (options ?? [])
            }),
            url = url ?? urlRoot,
            AsJson = Json.Document(bytes, encoding ),
            AsText = Text.FromBinary( bytes, encoding ),
            Json.HasError = ( try AsJson )[HasError],
            info = Value.Metadata( bytes ),
            log_message = Jsonify(messageArgs),
            messageArgs = [
                Name = "Invoke-RestMethod",
                url = url,
                options = options
            ],

            bytes = Diagnostics.Trace(
                    TraceLevel.Error, log_message,
                    () =>  Web.Contents( urlRoot, options),
                    true
                ),
            summary = [
                baseUrl = url,
                StatusCode = info[Response.Status],
                Uri = info[Content.Uri](),
                Headers = info[Headers]? ?? null,
                Request.Options = info[Request.Options] ?? null,
                Content.Name = info[Content.Name],
                Content.Type = info[Content.Type],
                AsJson = AsJson,
                AsText = AsText,
                Json.HasError = Json.HasError,
                Info = info,
                ErrorMessage = try AsJson catch (e) => e[Message],
                ActivityId = Diagnostics.ActivityId()
            ]
        in
            summary,

    // Convert to Json, then decode as a string. sometime useful because the UI auto decodes
    Jsonify = (source as any, optional options as nullable record) as text => let
            encoding = options[encoding]? ?? TextEncoding.Utf8,
            messageArgs = source,
            bytes = Json.FromValue( messageArgs, encoding ),
            render = Text.FromBinary( bytes, encoding )
        in render,

    Summary = {
        WebRequest.DebugInfo(
            urlRoot, [
                RelativePath = "anything",
                Query = [ User = "nin", Species = "#(0001f412)" ]
            ]
        ),
        WebRequest.DebugInfo(
            urlRoot, [
                RelativePath = "anything2432",
                Query = [ User = "Jen", Species = "#(0001f98e)" ]
            ]
        )
    },
    SummaryTable = Table.FromRecords( Summary, null, MissingField.Error )
in
    SummaryTable