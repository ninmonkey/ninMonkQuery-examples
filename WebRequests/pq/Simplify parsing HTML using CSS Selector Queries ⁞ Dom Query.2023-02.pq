// Fetch Web Address
let
    /* answering this thread:
    Using CSS Selector Queries lets you extract data from a webpage in a cleaner way than manually parsing it.

    With the dom Inspector, I saw the address was within a 'span' that has the class name 'address'. That returns one result

        <https://www.reddit.com/r/PowerQuery/comments/111fbx1/help_with_splitting_a_column_with_no_deliminator/>
    */
    UseCachedValue = false,
    Html.QueryAddress = (url as text) =>
        let
            response = Web.BrowserContents(url),
            query = Html.Table(response, {{"Address", "span.address"} })
        in
            query,

    Text.ParseAddress = Value.ReplaceType( Text.ParseAddress.Impl, Text.ParseAddress.Type ),
    Text.ParseAddress.Type = type function (
        source as text
    ) as record meta [
        Documentation.Name = "Text.ParseAddress",
        // Documentation.LongDescription = "Parses an address string into a record with the following fields: Original, Lines, Segments, Part1, Part2, State, Zip",
        Documentation.LongDescription = Text.Combine({
            "Converts an address from raw text to Segments"
            },"<br>"),
        Documentation.Examples = {
            [
                Description = "Parse an address",
                Code = Text.Combine({
                    "Text.ParseAddress(""5901 Old Shell Rd, Mobile, AL 36608"")"
                }, "#(cr,lf)"),
                // Result = "Text.ParseAddress(""5901 Old Shell Rd, Mobile, AL 36608"")"
                Result = Text.Combine({
                    "as Equivalent Json: [",
                    "   ""Source"": ""5901 Old Shell Rd, Mobile, AL 36608"",",
                    "    ""Part1"": ""5901 Old Shell Rd"",",
                    "    ""Part2"": ""AL 36608"",",
                    "    ""State"": ""AL"",",
                    "      ""Zip"": ""36608"" ]" }, "#(cr,lf)")

            ]
        }

    ],
    Text.ParseAddress.Impl = (source as text) as record =>
        [
            Original = source,
            Lines = Text.Split( Text.Trim(Original), "," ),
            Part1 = Text.Trim( Lines{0} ),
            Part2 = Text.Trim( Lines{1} ),
            State = Text.BeforeDelimiter( Part2, " ", Occurrence.First ),
            Zip   = Text.AfterDelimiter(  Part2, " ", Occurrence.First )
    ],

    RawText =
        if UseCachedValue then "5901 Old Shell RdMobile, AL 36608"
        else  Html.QueryAddress( "https://www.yellowpages.com/mobile-al/mip/via-emilia-21779981" ){0}[Address],

    Addr = Text.ParseAddress( RawText )
in
    Addr

// Xkcd Comic
let
    Html.QueryComic = (url as text) =>
        let
            response = Web.BrowserContents(url),
            query = Html.Table(response, {{"Comic", "div#comic img", each _ } })
        in
            query,

    Comic = Html.QueryComic("https://xkcd.com"),

    #"Expanded Comic" = Table.ExpandRecordColumn(
            Comic, "Comic",
            {"TagName", "TextContent", "Attributes"}, {"TagName", "TextContent", "Attributes"}
        )[Attributes]{0}
in
    #"Expanded Comic"