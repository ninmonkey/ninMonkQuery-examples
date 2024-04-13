let
    Summary = [
        baseUrl = "https://api.openai.com",
        ApiKey = File.Contents( "H:\data\data_notgit\2024\Secrets\OpenAI-BasicChatCompletions.env"),

        response = Web.Contents( baseUrl, options ),
        options = [
            // RelativePath = "v1/chat/completions",
            RelativePath = "/v1/chat/completions",
            Headers = headers,
            // Body = [],
            Content = payload,
            // Query = [],
            // see: <https://learn.microsoft.com/en-us/power-query/wait-retry#putting-it-all-together>
            // Timeout = #duration(0, 0, 0, 30),
            // ApiKeyName = "",
            // IsRetry = ,
            ManualStatusHandling = { 400, 404, 408, 429, 500, 503, 504, 509}
        ],
        headers = [
            Authorization = "Bearer " & Text.FromBinary( ApiKey, TextEncoding.Utf8 )
        ],
        // model: see: <https://platform.openai.com/docs/models/model-endpoint-compatibility>
        Model = "gpt-3.5-turbo", // for /v1/chat/completions
        // Model = "gpt-3.5-turbo-instruct", // for legacy /v1/completions
        payload =  Json.FromValue( prompts, TextEncoding.Utf8 ),
        prompts = [
            model = Model,
            messages = {
                [ role = "system", content = "You are a helpful assistant"],
                [ role = "user", content = "Who is the best teenage mutant ninja turtle?"],
                [ role = "assistant", content = "Obviously Donatello is"],
                [ role = "user", content = "Explain your rationale"]
            },
            temperature       = 1,
            max_tokens        = 20,
            top_p             = 1,
            frequency_penalty = 0,
            presence_penalty  = 0
        ],
        withInfo = Value.Metadata( response ),
        Response = [
            Bytes        = response,
            Meta         = Value.Metadata( Bytes ),
            Json         = Json.Document( Bytes ),
            IsJson       = not ( try Json )[HasError],
            RawText      = Text.FromBinary( response, TextEncoding.Utf8 ),
            StatusCode   = Meta[Response.Status],
            RequestUrl   = Meta[Content.Uri](),
            Content.Type = Meta[Content.Type]
        ]
    ],
    Response = Summary[Response]
in
    Response