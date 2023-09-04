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