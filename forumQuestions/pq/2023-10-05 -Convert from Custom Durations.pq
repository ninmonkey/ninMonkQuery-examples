let
    /*
    this question came from: <https://www.reddit.com/r/PowerBI/comments/1772433/help_converting_duration_formatted_like_1h_56m_1s>

    this self is from:
        <https://github.com/ninmonkey/ninMonkQuery-examples/blob/96fd33ab255ceeccacc6f67048c9d2377ed6e21f/Types/pq/joining-text%20as%20pipes%20from%20auto-coerced-column-values.pq>
    */

    // minimal snippet to preview nested values as text. ex: nested lists
    Xray = (source as any, optional options as nullable record) as text => [
        options = Record.Combine({defaults, (options ?? []) }),
        defaults = [ WrapText = true ],
        bytes = Json.FromValue(source),
        string = Text.FromBinary( bytes, TextEncoding.Utf8 ),
        wrapLines = Text.Replace( string, ",", ",#(cr,lf)"),
        ret = if options[WrapText] then wrapLines else string
    ][ret],

    Source = Table.FromRows(Json.Document(Binary.Decompress(Binary.FromText("i45WMsxQMDHPVTAvVorViVYyNYPSuWDK0ChDwTRXwdAYKBoLAA==", BinaryEncoding.Base64), Compression.Deflate)), let _t = ((type nullable text) meta [Serialized.Text = true]) in type table [RawText = _t]),


    // values like "10s" or "3m"
    Splitter.SplitDigitWithSuffix = // Splitter.SplitTextByDigitWithSuffixTransition =
        Splitter.SplitTextByCharacterTransition(
        {"0".."9"}, (c) => not List.Contains({"0".."9"}, c) ),

    List.SelectBySuffix2 = ( items as list, unit as text ) as any =>
        try Number.From( List.Select( items, (i) => i{1} = unit ){1} )
        catch (e) => e[Message],
    List.SelectBySuffix.raw = ( items as list, unit as text ) as any =>
        List.First(
            List.Select( items, (i) => i{1} = unit ), null ){0}?,

    // expects a list of pairs of 2 elements, first is the digit, 2nd is the unit



    // sugar to make it easier to embed powerquery as a string literal
    DocExpand = (source as text) =>
        Text.Replace( source, "␞", "#(0022)" ),

    List.SelectBySuffix.Func = ( items as list, unit as text ) as any =>
        List.First(
            List.Select( items,
                (i) => i{1} = unit ), null ){0}?,
        // catch (e) => e[Message],

    List.SelectBySuffix.Type = type function (
        items as (type { text }),
        unit as text
    ) as text meta [
        Documentation.Name = "List.SelectBySuffix",
        Documentation.LongDescription = Text.Combine({
            "foo", "bar"
        }, "<br>"),
        Documentation.Examples = {
            [
                Description = "Selects the first item in a list that ends with the specified suffix",
                Code = DocExpand( "List.SelectBySuffix( { {␞2␞, ␞d␞}, {␞3␞, ␞h␞} }, ␞h␞)" ),
                Result = DocExpand("3")
            ],
            [
                Description = "Selects the first item in a list that ends with the specified suffix",
                Code = DocExpand( "List.SelectBySuffix( { {␞2␞, ␞d␞}, {␞3␞, ␞h␞} }, ␞d␞)" ),
                Result = DocExpand("2")
            ]
        }
    ],
    List.SelectBySuffix = Value.ReplaceType( List.SelectBySuffix.Func, List.SelectBySuffix.Type ),

    summary = [
        x  = Xray,
        sample = "1d 3z 3m 5s",
        s_segs = Text.Split(sample, " "),
        x_segs = x(s_segs),
        s_first_raw = s_segs{0},
        s_first = Splitter.SplitDigitWithSuffix( s_segs{0} ),
        s_f = List.SelectBySuffix( s_first, "s"),
        s_secs = List.SelectBySuffix( s_first, "s"),

        s_pairs = List.Transform( s_segs, (pair) => Splitter.SplitDigitWithSuffix( pair )),

        ray_pairs = Xray(s_pairs),

       Days =
            List.SelectBySuffix( s_pairs, "d" ) ?? 0,
        Hours =
            List.SelectBySuffix( s_pairs, "h" ) ?? 0,
        Minutes =
            List.SelectBySuffix( s_pairs, "m" ) ?? 0,
            // x(List.SelectBySuffix( s_pairs, "m" )) ?? 0,
        Seconds =
            List.SelectBySuffix( s_pairs, "s" ) ?? 0,

        inst =
             #duration( 0, Hours, Minutes, Seconds ),
            //?? 0,

        // now = Date.AddDays( DateTime.LocalNow() , 2),
        // dur = Duration.ToRecord( #duration(1,3,4,5) ),

        // durFrom = Duration.From( dur ),


        s_mins = List.SelectBySuffix( s_pairs, "m")

    ],


    Duration.FromCustom = (input as text) as any => [
        source = Text.Lower( Text.Trim( input ) ),
        segments = Text.Split(source, " "),
        splitSegs = List.Transform( segments, (item) => Splitter.SplitDigitWithSuffix( item  )  ),
        a = splitSegs{0},
        first = splitSegs{0},
        // firstSplit = Splitter.SplitDigitWithSuffix( first ),
        Days =
            List.SelectBySuffix( splitSegs, "d" ) ?? 0,
        Hours =
            List.SelectBySuffix( splitSegs, "h" ) ?? 0,
        Minutes =
            List.SelectBySuffix( splitSegs, "m" ) ?? 0,
        Seconds =
            List.SelectBySuffix( splitSegs, "s" ),
            //?? 0,
        inst = #duration( Days, Hours, Minutes, Seconds )
    ],

    /*
= Table.SplitColumn(#"Expanded Coerce", "RawText", Splitter.SplitTextByCharacterTransition(
    {"0".."9"}, (c) => not List.Contains({"0".."9"}, c)), {"RawText.1", "RawText.2", "RawText.3", "RawText.4"})
    */
    #"Changed Type" = Table.TransformColumnTypes(Source,{{"RawText", type text}}),
    #"Added Custom" = Table.AddColumn(#"Changed Type", "Coerce", each Duration.FromCustom( [RawText] )),
    #"Expanded Coerce" = Table.ExpandRecordColumn(#"Added Custom", "Coerce", {"source", "segments", "splitSegs", "a", "first", "Days", "Hours", "Minutes", "Seconds", "inst"}, {"source", "segments", "splitSegs", "a", "first", "Days", "Hours", "Minutes", "Seconds", "inst"}),
    finalSummary = summary
in
    finalSummary