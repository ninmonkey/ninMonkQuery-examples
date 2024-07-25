let
    /*
    the original question: <https://www.reddit.com/r/PowerBI/comments/1eay2qp/make_changescorrections_to_previously_made_column/>
    */
    Source = Table.FromRows(Json.Document(Binary.Decompress(Binary.FromText("bY5BCsIwEEWvMnQdd17AKrhRK0RwUboY6aQZTDOSJpvi4R0t3bn58If3H9O21UVS9mDFIWxhIsyUYAOJB5/hDWeJMxqwGHttd8+Z4MXDSDFTDw0HTcGnEhL4i9zsfld1ZvU6ET2eOJJa6lBI27Jq/q5+cUz4gKsUp4/YEUNQokaeycChTHn1LKPuAw==", BinaryEncoding.Base64), Compression.Deflate)), let _t = ((type nullable text) meta [Serialized.Text = true]) in type table [#"Full Name" = _t]),
    #"Changed Type" = Table.TransformColumnTypes(Source,{{"Full Name", type text}}),
    #"Split Column by Delimiter - old" = Table.SplitColumn(#"Changed Type", "Full Name",
        Splitter.SplitTextByDelimiter("|", QuoteStyle.Csv), {"Full Name.1", "Full Name.2", "Full Name.3", "Full Name.4"}
    ),
    #"Split Column by Delimiter" = Table.SplitColumn(#"Changed Type", "Full Name",
        Splitter.Sofa
        // Splitter.SplitTextByDelimiter("|", QuoteStyle.Csv), {"Full Name.1", "Full Name.2", "Full Name.3", "Full Name.4"}
    ),

    /*
    about: custom splitting by delimiter "|"

        - always ignore the trailing "TSCO"
        - 3 or less columns expand as:
            a, b, c
        - 4 columns expand swapped as:
            a, b, d, c

        - where a, b, c, d are:
            - Size
            - Fabric Option
            - Mattress Foam Option
            - Leg Option
    */
    Splitter.Sofa = (source as text) => [
        crumb      = List.RemoveLastN( Text.Split( source, "|" ), 1 ),
        shouldSwap = List.Count( crumb ) = 4,
        return     = [
            Size                   = crumb{0}?,
            #"Fabric Option"       = crumb{1}?,
            #"Leg Option"          =
                if shouldSwap then crumb{3}?
                else crumb{3}?,

            #"Mattress Foam Option" =
                if shouldSwap then crumb{2}?
                else crumb{3}?
        ]
    ][return],
    a =  Table.SplitColumn ,
    b = Splitter.Sofa( #"Changed Type"{0}[Full Name] ),
    fin = #"Split Column by Delimiter"
    // #"Changed Type1" = Table.TransformColumnTypes(#"Split Column by Delimiter",{{"Full Name.1", type text}, {"Full Name.2", type text}, {"Full Name.3", type text}, {"Full Name.4", type text}})
in
    fin