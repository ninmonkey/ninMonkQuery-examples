    let
        // docs: <https://learn.microsoft.com/en-us/powerquery-m/web-contents>
        // if you had the url:
        example_url = "www.foo.com/someApi/aa/bb?key=value&id=1234",
        url = "www.foo.com",
        // only up to dotcom, then end, shortest possible string
        options = [
            RelativePath = "/someApi/aa/bb",
            // everything up to the first "?"
            Query = [
                // your query string
                key = "value",
                id = 1234
            ]
        ],
        response = Web.Contents(url, options)
    in
        response
