// HtmlParse for True Parsing
let
    RawHtml = "<html><body>
        <a href=""/003Dn00000b69ED"" target=""\_blank"">Richard Radnay</a>
        <a href=""/12314543"" target=""\_blank"">Jane Doe</a>
        </body></html>",
    // SingleHtml = "<a href=""/003Dn00000b69ED"" target=""\_blank"">Richard Radnay</a>",

    ParsedAll = Html.Table( RawHtml, { {"Link", "a", each _ }}),

    #"Expanded Link" = Table.ExpandRecordColumn(ParsedAll, "Link", 
        { "TagName", "TextContent", "Attributes"}, 
        { "Tag", "Content", "Attributes" } ),

    #"Expanded Attributes" = Table.ExpandRecordColumn( #"Expanded Link", "Attributes", {"href"}, {"href"} ),
    #"Changed Type" = Table.TransformColumnTypes(#"Expanded Attributes", {
        {"href", type text}, {"Content", type text}, {"Tag", type text} })
in
    #"Changed Type"

// Raw Split by Long Delimiters
let 
    RawSrc = "<a href=""/003Dn00000b69ED"" target=""\_blank"">Richard Radnay</a>",

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
in 
    final

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