let Summary = [
    /* about: A reddit post was using a language model API .
        This shows how you can write inline Json more idiomatically

        question was: <https://www.reddit.com/r/PowerBI/comments/1bg4fgi/integrating_chatgpt_with_powerquery_for_aidriven/>

    */
    JsonInfo = "payload",

    InlineJson = [
        model = "gpt-3.5-turbo",
        messages = {
            [ role = "system", content = "You are an analytics expert, your role is to make the best analysis you can with the data provided" ],
            [ role = "system", content = "You will read and understand this data " & JsonInfo ],
            [ role = "system", content = "You will always answer in JSON structures without any decoration nor text explanation" ],
            [ role = "user", content = "You will return the data with the same structure plus an additional field named ""Label"". In this field you will infer the label male, female or NA from the name"]
        }
    ],

    asJson = Json.FromValue( InlineJson, TextEncoding.Utf8 ),
    asText = Text.FromBinary( asJson, TextEncoding.Utf8 ),

    // this line just formats your json without extra space, so that you can test whether they are equivalent
    fromReddit = Text.FromBinary(Json.FromValue( Json.Document(
        RawRedditSource, TextEncoding.Utf8 ) , TextEncoding.Utf8 ), TextEncoding.Utf8 ),

    AreExactlyEquivalent = asText = fromReddit,

    RawRedditSource = "{
                    ""model"": ""gpt-3.5-turbo"",
                    ""messages"": [
                        {
                            ""role"": ""system"",
                            ""content"": ""You are an analytics expert, your role is to make the best analysis you can with the data provided""
                        },
                        {
                            ""role"": ""system"",
                            ""content"": ""You will read and understand this data " & "payload" & """
                        },
                        {
                            ""role"": ""system"",
                            ""content"": ""You will always answer in JSON structures without any decoration nor text explanation""
                        },
                        {
                            ""role"": ""user"",
                            ""content"": ""You will return the data with the same structure plus an additional field named \""Label\"". In this field you will infer the label male, female or NA from the name""
                        }
                    ]
                }"

]
in Summary