let
   CodeIsFrom = "https://github.com/ninmonkey/ninMonkQuery-examples/tree/main/WebRequests",

    // if you're not sure, you can try
    cat_parts = Uri.Parts("https://www.foo.com/api/catfacts?query=fluffy&limit=10"),

    // if you have this full url
    Example_Full_Url = "https://gitloggerfunction.azurewebsites.net/Get-GitLogger?Repository=https://github.com/StartAutomating/GitLogger&MetricName=NetLineCadence",

    /*
    base url
        is everything up to the domain, then stops

            https://gitloggerfunction.azurewebsites.net

    RrelativePath
        is everything from the domain to the question mark


        usually it's something like
            /api/employees

    Query
        is a record of everything after the question mark.
        They are key = value pairs, separated by "&"s
    */


    /*
        here's a simple way to use default variables in functions
        1] declare the variable as nullable something

            Function = ( name as nullable text ) =>

        2] set the default value like this

             name = name ?? "default"


        if null, it uses the defaults
        the "??" is a null coalescing operator
    */
    InvokeAPI = (
        baseUrl as nullable text, relativePath as nullable text,
        query as nullable record
    ) => let
            baseUrl = baseUrl ?? "https://gitloggerfunction.azurewebsites.net",
            options = [
                RelativePath = relativePath ?? "Get-GitLogger",
                Query = query ?? [
                    Repository = "https://github.com/StartAutomating/GitLogger",
                    MetricName = "NetLineCadence"
                ],
                ManualStatusHandling = { 404, 427, 500 }
            ],
            bytes = Web.Contents( baseUrl, options ),
            Summary = [
                bytes       = bytes,
                Meta        = Value.Metadata( bytes ),
                Json        = Json.Document( bytes, TextEncoding.Utf8 ),
                IsJson      = not ( try Json )[HasError],
                AsTable     = try Table.FromRecords( Json ) catch (e) => e[Message],
                TableSchema = try Table.Schema( AsTable )   catch (e) => e[Message]
            ]
        in
            Summary,

    /*
    here is the *actual* code. the rest is a wrapper to make it simple
    */
    ApiResponse = {
         InvokeAPI( null, null, null ),

         InvokeAPI( null, null, [
             Repository = "https://github.com/ninmonkey/notebooks",
             MetricName = "CommitsByLanguage"
         ] ),

         InvokeAPI( null, null, [
             Repository = "https://github.com/StartAutomating/GitLogger",
             MetricName = "CommitsByLanguage"
         ] )
    },

    /* then display as a table */
    RecordList.Type = type { Record.Type }, // this is extra, but it makes the UI expand cleaner
    api_schema = type table [bytes = binary, Meta = Record.Type, Json = RecordList.Type, IsJson = Logical.Type, AsTable = Table.Type, TableSchema = Table.Type ],
    FinalTable = Table.FromRecords( ApiResponse, api_schema )
in
    FinalTable