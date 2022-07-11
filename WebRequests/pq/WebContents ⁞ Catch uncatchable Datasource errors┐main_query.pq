// WebRequest
let
    /*

    About:

    Without ManualStatusHandling, you can't catch exceptions thrown by Web.Contents.

        Try appears to work, it says [HasError] is false.

                (try Expression)[HasError]

        but [Value] always resolves as an exception (that's not caught by you)
    */
    tests = {
        [
            Label = "Base",
            Response =
                Web.Contents( "https://catfact.ninja", [ RelativePath = "breeds"] )
        ],
        [
            Label = "Uncatchable",
            Response =
                try Web.Contents( "https://httpbin.org",
                    [ RelativePath =  "/status/codes/418" ] )
                catch (e) =>
                    "Error, but we caught it" meta e[Message]
        ],
        [
            Label = "Invalid Operator",
            Response =
                try 1 > "a" * 4
                catch (e) =>
                    "Error, but we caught it" meta e
        ],
        [
            Label = "Catchable Web",
            Response =
                try Web.Contents( "https://httpbin.org",
                    [ RelativePath =  "/status/codes/418" ] )
                catch (e) =>
                    "Error, but we caught it" meta e
        ],
        [
            Label = "Catchable Web using StatusHandling",
            Response =
                try Web.Contents( "https://httpbin.org",
                    [ RelativePath =  "/status/codes/418",
                    ManualStatusHandling =
                        {401, 402, 404} & {405..500}
                    ] )
                catch (e) =>
                    "Error, but we caught it" meta e
        ]
    },
    Summary = Table.FromRecords(
        tests,
        type table[
            Label = text,
            Response = nullable binary
        ],
        MissingField.Error),

    col_json = Table.AddColumn(
        Summary, "Json",
        (row) =>
            try
                Json.Document( row[Response] , TextEncoding.Utf8 )
            catch (e) =>
                null meta [Exception = e],
        type nullable record
    ),
    col_text = Table.AddColumn(
        col_json, "Response as Raw Text",
        (row) =>
            Text.FromBinary( row[Response], TextEncoding.Utf8 ),
        type text
    ),
    error_text = Table.AddColumn(
        col_text, "Error Message",
        (row) =>
             if row[Response] <> null
            then Value.Metadata( row[Response] ) else null,
        type nullable record
    )
in
    col_text