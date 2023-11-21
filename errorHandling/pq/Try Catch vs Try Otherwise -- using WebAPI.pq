
WIP scratch
That's the older syntax, which is totally still valid. I've been meaning to write up some more examples.


Imagine this pq

    try File.Contents(...) otherwise null

It's similar to this `c#`

    try {
        // request
    } catch (Exception e) {
        return null;
    }

Notice that all exceptions are consumed. Including ones that should trickle up.

Maybe it's expected for the file to not always exist, so it returns null.  What if the file does exists, but it's being written to by another process? That would also return null

Or if there's an error in the parameters I pass to my Web request function, like passing a number instead of a string.

- basically you can capture an exception
- act on the error record
- if it matches the error I want, return null
- otherwise let the error bubble up to the caller, as if I didn't catch it

    try {
        File.Contents( ... )
    } catch (Exception e) {
        if( e.Message -match 'network path' ) {
            return null
        }
        // if it's not network IO related, don't swallow all errors
        throw e
    }


let
    urlBase = "https://httpbin.org",
    WebAPI = ( relativePath as text , optional options as nullable record) as record =>
        let
            encoding = options[Encoding]? ?? TextEncoding.Utf8,
            // options = Record.Combine({
            //     defaults,
            //     options ?? []
            // }),
            // defaults = [
            //     Encoding = TextEncoding.Utf8
            // ],
            // params = Record.Combine({
            //     sharedParams,
            //     [ RelativePath = relativePath ]
            // }),
            // bytes = Web.Contents( urlBase, sharedParams),
            // Info = Value.Metadata( bytes )
        in
            [
                // Json          = Json.Document( bytes, encoding  ),
                // Json.HasError = (try Json)[HasError],
                Text = Text.FromBinary( bytes, TextEncoding.Utf8 ),
                // Lines.FromBinary( bytes, QuoteStyle.None, true, encoding ),
                // Request.Uri   = Info[Request.Uri],
                // Info          = Value.Metadata( bytes ),
                // WebContents.HasError = (try bytes)[HasError],
                Response      = bytes

            ],
    {
        resp = Web.Contents( "https://httpbin.org", [ RelativePath = "status/404"] ),
        resp = Web.Contents( "https://httpbin.org", [ RelativePath = "status/404"] ),
    },

       // query =
    //     Web.Contents( "https://httpbin.org", sharedParams),

    // notActualJson =
    //     Web.Contents( "https://httpbin.org",  sharedParams ),

    maybeNumbers = { 300, 500, "500.0", 100  / 0 },
    relativePaths = List.Transform(
        maybeNumbers, (item) => "status/" & Text.From(item) ),


    functionArgs = { 500, 200, 300, "300", "500" },
    // results = List.Transform

    WebAPI = ( relativePath as text , optional options as nullable record) as record =>
        let
            options = Record.Combine({
                defaults,
                options ?? []
            }),
            defaults = [
                Encoding = TextEncoding.Utf8
            ],
            encoding = options[Encoding]? ?? TextEncoding.Utf8,
            params = Record.Combine({
                sharedParams,
                [ RelativePath = relativePath ]
            }),
            bytes = Web.Contents( urlBase, sharedParams),
            Info = Value.Metadata( bytes )
        in
            [
                // Json          = Json.Document( bytes, encoding  ),
                // Json.HasError = (try Json)[HasError],
                Text = Text.FromBinary( bytes, TextEncoding.Utf8 ),
                // Lines.FromBinary( bytes, QuoteStyle.None, true, encoding ),
                // Request.Uri   = Info[Request.Uri],
                // Info          = Value.Metadata( bytes ),
                // WebContents.HasError = (try bytes)[HasError],
                Response      = bytes

            ],
    WebAPI.Type = type table [
        Json = Any.Type,
        Contents.Text

    ],

        // Web.Contents( "https://httpbin.org", [ RelativePath = "status/500" ] ),
    fin = Table.FromList( relativePaths, Splitter.SplitByNothing(), type table [ RelativePath = Text.Type ], null, ExtraValues.Error),
    // column_InvokeApi = Table.AddColumn( fin, "Response", (row) => WebAPI( row[RelativePath] ), WebAPI.Type ),
    // column_InvokeApi = Table.AddColumn( fin, "Response", (row) => WebAPI( row[RelativePath], []), type record ),
    // column_InvokeApi = Table.AddColumn( fin, "Response", (row) => [ state = "Nothing" ] ),
    column_InvokeApi = Table.AddColumn( fin, "Response", (row) => WebAPI( row[RelativePath] ), type any ),
    Summary = [
        Source = fin,
        try1 =
            WebAPI( "/status/200", null ),
        invokeApi =
            try column_InvokeApi
            catch (e) => e
    ],
    invokeApi = Summary,
    invokeApi1 = invokeApi[invokeApi]
in
    invokeApi1
    // #"Expanded Response"