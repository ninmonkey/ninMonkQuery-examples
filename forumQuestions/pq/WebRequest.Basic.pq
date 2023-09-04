let
    WebRequest = ( baseUrl as text, optional options as nullable record ) as record =>
            let
                encoding = options[Encoding]? ?? TextEncoding.Utf8,
                baseUrl = "foo.zendesk.com",
                bytes = Web.Contents( baseUrl, options ),
                result = [
                    info = Value.Metadata( bytes ),
                    Json =
                        try Json.Document( bytes, encoding )
                        catch (e) => e[Message]
                ]
            in
                result
    in
        WebRequest