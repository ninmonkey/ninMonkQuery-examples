let 
    /* to make refreshing easier:
       - the first argument to Web.Contents should end at the domain. Nothing more.
       - making it be a "report parameter" instead of a basic variable allows variables but still be a refreshable query
       - Everything else goes into relativePath, 
       - You can use query to build a query string from a record
    */

    WebRequest = (
        baseUrl as nullable text,  // optional is implicitly 'nullable type'
        optional relativePath as text,
        optional query as record
    ) => let
            baseUrl = baseUrl ?? "https://httpbin.org",
            options = [
                RelativePath = relativePath ?? null,
                Query = query ?? [],  

                // this allows you to catch HTTP Status errors. ( except for 401 and 403 which are Auth )
                ManualStatusHandling = { 400, 404, 427, 500 }                
            ],
            bytes = Web.Contents( baseUrl, options ),
            Summary = [
                bytes           = bytes,
                Response.Status = Meta[Response.Status],
                FullRequestUrl  = Meta[Content.Uri](),
                Json            = Json.Document( bytes, TextEncoding.Utf8 ),
                IsJson          = not ( try Json )[HasError],
                AsText          = Text.FromBinary( bytes, TextEncoding.Utf8 ),
                Meta            = Value.Metadata( bytes )
            ]            
        in
            Summary,

    tests = [

        expectJson = WebRequest( "https://httpbin.org", "json" ),
        expectJson2 = WebRequest( "https://httpbin.org", "anything", [ 
            Text = "Hi world", 
            language = "en-US",
            pageNumber = Number.ToText( 9 )
        ] ),
        expectErrorCodes = WebRequest( "https://httpbin.org", "/status/500" )
    ],
    TestSummary = Table.FromRecords( Record.FieldValues( tests ) ),
    SummaryWithTypes   = Table.TransformColumnTypes( TestSummary,
        {
            {"Response.Status", Int64.Type}, 
            {"FullRequestUrl", type text},
            {"IsJson", type logical},
            {"AsText", type text} 
        }, 
        "en-us" )


in
    SummaryWithTypes
