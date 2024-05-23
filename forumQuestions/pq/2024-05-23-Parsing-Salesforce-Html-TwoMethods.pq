// Using Html Parsing
let a = null, Summary = [
    RawHtml = "<html><body>
        <a href=""/003Dn00000b69ED"" target=""\_blank"">Richard Radnay</a>
        <a href=""/12314543"" target=""\_blank"">Jane Doe</a>
        ",

    Parsed = Html.Table( RawHtml, {
        { "Url", "a", each _ }
    })

    // delimsList = { "<a href=""", """ target=""_blank"""">", "</a>"},
    // rendList = Text.Combine( delimsList, "#(cr,lf)" ),
    // rendSplit = Text.Combine( splitUrl, "#(cr,lf)" ),
    // SplitSaleTag = Splitter.SplitTextByEachDelimiter( delimsList, QuoteStyle.None ),
    // splitUrl = SplitSaleTag( RawSrc ),
    // s0 = Text.AfterDelimiter(RawSrc, "<a href="""),
    // s1 = Text.BeforeDelimiter(s0, """"),


    // parseUrl = (rawTag as text) as record => [
    //     // parse html without a parser, but try to be strict
    //     strip_href = Text.AfterDelimiter( rawTag, "<a href="""  ),
    //     only_href = Text.BeforeDelimiter(strip_href, """" ),

    //     strip_close_a = Text.BeforeDelimiter( rawTag, "</a>" ),
    //     a_text_only = Text.AfterDelimiter(strip_close_a, ">" ),
    //     ret = [ FullRawText  = rawTag, Href = only_href, Name = a_text_only ]
    // ][ret],
    // // ], // toggle lines to see each step in the calculation

    // final = parseUrl( RawSrc )

],
    Parsed = Summary[Parsed],
    #"Changed Type" = Table.TransformColumnTypes(Parsed,{{"Url", type any}}),
    #"Expanded Url" = Table.ExpandRecordColumn(#"Changed Type", "Url", {"TagName", "TextContent", "Attributes"}, {"Url.TagName", "Url.TextContent", "Url.Attributes"}),
    #"Expanded Url.Attributes" = Table.ExpandRecordColumn(#"Expanded Url", "Url.Attributes", {"href"}, {"Url.Attributes.href"}),
    #"Changed Type1" = Table.TransformColumnTypes(#"Expanded Url.Attributes",{{"Url.Attributes.href", type text}, {"Url.TextContent", type text}, {"Url.TagName", type text}})
in
    #"Changed Type1"

// SingleString UsingSplits by long Delimiters
let Summary = [
    Source = Table.FromRows(Json.Document(Binary.Decompress(Binary.FromText("i45Wiik1MDBOTlTIKEpNs41R0gfyXPIMQCDJzNLVJUZJoSSxKD21BCgXExOflJOYlx0D0ZQalJmckViUohCUmJKXWAkxSD8RIqcUGwsA", BinaryEncoding.Base64), Compression.Deflate)), let _t = ((type nullable text) meta [Serialized.Text = true]) in type table [RawHtml = _t]),
    #"Changed Type" = Table.TransformColumnTypes(Source,{{"RawHtml", type text}}),
    
    RawSrc_FromTable = #"Changed Type"{0}[RawHtml],

    RawSrc = "<a href=""/003Dn00000b69ED"" target=""\_blank"">Richard Radnay</a>",


    delimsList = { "<a href=""", """ target=""_blank"""">", "</a>"},
    rendList = Text.Combine( delimsList, "#(cr,lf)" ),
    rendSplit = Text.Combine( splitUrl, "#(cr,lf)" ),
    SplitSaleTag = Splitter.SplitTextByEachDelimiter( delimsList, QuoteStyle.None ),
    splitUrl = SplitSaleTag( RawSrc ),
    s0 = Text.AfterDelimiter(RawSrc, "<a href="""),
    s1 = Text.BeforeDelimiter(s0, """"),


    parseUrl = (rawTag as text) as record => [
        // parse html without a parser, but try to be strict
        strip_href = Text.AfterDelimiter( rawTag, "<a href="""  ),
        only_href = Text.BeforeDelimiter(strip_href, """" ),

        strip_close_a = Text.BeforeDelimiter( rawTag, "</a>" ),
        a_text_only = Text.AfterDelimiter(strip_close_a, ">" ),
        ret = [ FullRawText  = rawTag, Href = only_href, Name = a_text_only ]
    ][ret],
    // ], // toggle lines to see each step in the calculation

    final = parseUrl( RawSrc )

],
    final = Summary[final] in final

// PBIBlog Html Expand Extra Attributes
let 
    a = null,
    Summary = [
        Response = Web.Contents("https://powerbi.microsoft.com/en-us/blog/", [ManualStatusHandling={400, 401, 402, 404, 405} &  {405..490} & {500..599}]),
        RawText = Text.FromBinary( Response ),
        ParseHtml = Html.Table( RawText, {{"Link", "a", each _ }})



    ],
    ParseHtml = Summary[ParseHtml],
    #"Expanded Link" = Table.ExpandRecordColumn(ParseHtml, "Link", {"TagName", "TextContent", "Attributes"}, {"Link.TagName", "Link.TextContent", "Link.Attributes"}),
    #"Expanded Link.Attributes" = Table.ExpandRecordColumn(#"Expanded Link", "Link.Attributes", {"class", "href", "id", "aria-label", "data-bi-name", "role", "title", "target", "rel"}, {"Link.Attributes.class", "Link.Attributes.href", "Link.Attributes.id", "Link.Attributes.aria-label", "Link.Attributes.data-bi-name", "Link.Attributes.role", "Link.Attributes.title", "Link.Attributes.target", "Link.Attributes.rel"})
in
    #"Expanded Link.Attributes"

// HtmlParse a Single String
let
    SingleHtml = "<a href=""/003Dn00000b69ED"" target=""\_blank"">Richard Radnay</a>",
    ParsedAll = Html.Table( SingleHtml, { {"Link", "a", each _ }}),
    #"Expanded Link" = Table.ExpandRecordColumn(ParsedAll, "Link", {"TagName", "TextContent", "Attributes"}, {"Tag", "Content", "Attributes"}),
    #"Expanded Attributes" = Table.ExpandRecordColumn(#"Expanded Link", "Attributes", {"href"}, {"href"}),
    #"Changed Type" = Table.TransformColumnTypes(#"Expanded Attributes",{{"href", type text}, {"Content", type text}, {"Tag", type text}})
in
    #"Changed Type"