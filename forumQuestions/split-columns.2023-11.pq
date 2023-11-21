let
    Source = Table.FromRows(Json.Document(Binary.Decompress(Binary.FromText("XU9NT4NAEP0rD87dZGFpjMdlO00JsEO2i9VUDqRi0hhqovTgvxdsNdiZ08y8r9nvQ5+ZnLyIphKm3nouycHqkiBgtPXYucwTqNRZETaLXwZEFKtk+UeZGKIy2PFI8bWzYDuDC0RybMwsuLwacEUW9GioEBv9QPAuoxVGLUcps/9ninupklFmOrPFOnN0uR8Pb90glFJSbKiogiD42Zdcbwmp45wucW5fzOkpZe1Wc8w18jJR8WRlzp/De999wLZ9N83t6fksZXw34PV4ekH/hUM7hE3zDQ==", BinaryEncoding.Base64), Compression.Deflate)), let _t = ((type nullable text) meta [Serialized.Text = true]) in type table [RawText = _t]),
    Culture = "en-us", // explicitly setting a query-default

    // helper functions for later
    // Trim and all caps
    TrimUpper = (source as text) as text =>
        Text.Upper( Text.Trim( source ), Culture ),
    // Trim and TitleCase
    TrimProper = (source as text) as text =>
        Text.Proper( Text.Trim( source ), Culture ),

    // CI: case-insenstitive search for text
    Text.ContainsCI = (source as text, substring as text) as logical =>
        Text.Contains( source, substring, Comparer.OrdinalIgnoreCase ),




    // if any single of these conditions is true, it marks the column as IsBad == true
    IsBadValue = (source as text) as logical => [
        crumbs = Text.Split( source, "-" ),
        crumbCount = List.Count( crumbs ),

        hasTicket =
            Text.ContainsCI( source, "ticket" ),

        hasTicketAsFirstSegment =
            Text.ContainsCI( crumbs{0}?, "ticket" ),

        // a list of values that evaluate as bools/logical types
        // if any of them are true, then it counds as a bad value
        failConditions = {

            crumbCount <> 3,
            not hasTicket,
            not hasTicketAsFirstSegment

        },

        return =  List.AnyTrue( failConditions )
    ][return],

    // try partial conversions. the return value is a record
    // that expands as new columns
    TryParse = ( source as text ) => [

        CrumbsRaw= Text.Split( source, "-" ),
        Crumbs = List.Transform( CrumbsRaw, (x) => Text.Trim(x) ),
        Part1 = Text.Combine( List.Range( Crumbs, 0, 2 ), "-" ),
        Part2 = Crumbs{2}?,
        Part3 = Crumbs{3}?,
        return = [
            Part1 = Part1,
            Part2 = Part2,
            Part3 = Part3
        ]

    ][return],

    IsBad_Column = Table.AddColumn(Source, "IsBad", each IsBadValue( [RawText] ), Logical.Type ),

   Segments_Column = Table.AddColumn(IsBad_Column, "Crumbs",
        each Text.Split( [RawText], "-" ), (type { text } )),

   TrySegments_Column = Table.AddColumn( Segments_Column,  "TryParse", each TryParse( [RawText] ), Record.Type ),

    // the rest is boilerplate
    #"Expanded TryParse" = Table.ExpandRecordColumn(
        TrySegments_Column, "TryParse",
        {"Part1", "Part2", "Part3"},
        {"Part1", "Part2", "Part3"} ),

    #"Changed Type" = Table.TransformColumnTypes( #"Expanded TryParse",{
        {"Part1", type text},
        {"Part2", type text},
        {"Part3", type text}
    }),

    #"Sorted Rows" = Table.Sort(#"Changed Type",{ { "IsBad", Order.Descending } })
in
    #"Sorted Rows"