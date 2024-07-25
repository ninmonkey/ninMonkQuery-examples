let
    /*
    the original question is from 2024-07-25: <https://www.reddit.com/r/PowerBI/comments/1eay2qp/make_changescorrections_to_previously_made_column/>

    You can get the pbix and this query here: <https://github.com/ninmonkey/ninMonkQuery-examples/tree/main/forumQuestions>

        They are named:
            "2024-07 - Split By Sofa Name.pbix"
            "pq/2024-07 - Split By Sofa Name.pq"
    */
    Json = Table.FromRows(Json.Document(Binary.Decompress(Binary.FromText("TY7LDoJADEV/pWGNK/0BwegKJRkTF4RFlQITZ6jOYyHh4y0mEDc3vcnpaasqObMLPShuEXbgCQM52IDTXR9ggoKHEVNQODTSbr0OBC/dWRoCNXDRRpLxKQQbPSNXle+TOq2SUjuE7WL0s38SSpvVVpBl94Ejo5WWs2mWOTP4eILEO5KTCz4QmX/5L04O71BybOVfZdHMRIZ6pBQO0QexRFqX6i8=", BinaryEncoding.Base64), Compression.Deflate)), let _t = ((type nullable text) meta [Serialized.Text = true]) in type table [#"Full Name" = _t]),
    Source = Table.TransformColumnTypes( Json ,{{"Full Name", type text}}),
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
                if shouldSwap
                then crumb{3}?
                else crumb{2}?,

            #"Mattress Foam Option" =
                if shouldSwap
                then crumb{2}?
                else crumb{3}?
        ]
    ][return],

    SplitByPipe = Table.AddColumn( Source, "SplitCols", each Splitter.Sofa( [Full Name] ), type record ),
    #"Expanded SplitCols" = Table.ExpandRecordColumn(
        SplitByPipe, "SplitCols",
        { "Size", "Fabric Option", "Leg Option", "Mattress Foam Option"} ),

    #"Changed Type" = Table.TransformColumnTypes(
        #"Expanded SplitCols", {
            {"Size", type text},
            {"Fabric Option", type text},
            {"Leg Option", type text},
            {"Mattress Foam Option", type text} } )

in
    #"Changed Type"