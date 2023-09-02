// Find RelativePath
let
    // I used a special character so I didn't have to escape double quotes 
    Uni = [ Quote = "#(0022)", SepSymbol = "␞" ],
    RawJson = Text.Replace( escapedJson, Uni[SepSymbol], Uni[Quote] ),
    doc = Json.Document( RawJson, TextEncoding.Utf8 ),
    escapedJson = "{ ␞tickets␞: [],
        ␞meta␞: {
            ␞has_more␞: true,
            ␞after_cursor␞: ␞xxx␞,
            ␞before_cursor␞: ␞yyy␞
        },
        ␞links␞: {
            ␞next␞: ␞https://example.zendesk.com/api/v2/tickets.json?page[size]=100&page[after]=xxx␞,
            ␞prev␞: ␞https://example.zendesk.com/api/v2/tickets.json?page[size]=100&page[before]=yyy␞
        } }",

    // drill down, use Uri.* to parse the url
    urlAsText = doc[links]?[next]?,
    segments = Uri.Parts( urlAsText ),
    
    myUrl = [ 
        RelativePath = segments[Path],
        Prefix = Text.BeforeDelimiter( urlAsText, RelativePath, 0),
        Query = segments[Query],
        RawUrl = urlAsText
    ]
        
in
    myUrl
