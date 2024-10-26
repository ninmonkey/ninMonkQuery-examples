let
    GitHubUser = "OscarValerock",
    GitHubRepo = "PowerQueryFunctions",
    BaseURL = "https://api.github.com",
    params = [
        RelativePath = Text.Format(
            "/repos/#[user]/#[repo]/git/trees/main", [
                user = GitHubUser,
                repo = GitHubRepo
            ]
        ),
        ManualStatusHandling = {400, 404, 429, 500 }
    ],
    rawText  = Text.FromBinary( response, TextEncoding.Utf8 ),
    response = Web.Contents( BaseURL, params ),
    Json     = Json.Document( response, TextEncoding.Utf8 ),
    TreeTble = Json[tree],

    #"Converted to Table" = Table.FromList(TreeTble,
        Splitter.SplitByNothing(), null, null, ExtraValues.Error),

    #"Expanded Column1" = Table.ExpandRecordColumn(
        #"Converted to Table", "Column1",
        { "path", "mode", "type", "sha", "url", "size" },
        { "path", "mode", "type", "sha", "url", "size" } ),

    #"Changed Type" = Table.TransformColumnTypes(#"Expanded Column1",{
        {"path", type text}, {"mode", type text}, {"type", type text},
        {"size", Int64.Type}, {"url", type text}, {"sha", type text}} ),

    info = [
        final = #"Changed Type", // final table to render
        Bytes = response,
        Meta  = Value.Metadata( Bytes ),
        Tinfo = Value.Type( Bytes )        // binary
        // MeTinfo = Value.Metadata( Tinfo )  // was empty
    ]
in
    info