let
    /*
    this question came from: <https://www.reddit.com/r/PowerBI/comments/1772433/help_converting_duration_formatted_like_1h_56m_1s>

    this self is from:
        <https://github.com/ninmonkey/ninMonkQuery-examples/blob/96fd33ab255ceeccacc6f67048c9d2377ed6e21f/Types/pq/joining-text%20as%20pipes%20from%20auto-coerced-column-values.pq>
    */
    Source = Table.FromRows(Json.Document(Binary.Decompress(Binary.FromText("i45WMsxQMDHPVTAvVorViVYyNYPSuWDK0ChDwTRXwdAYKBoLAA==", BinaryEncoding.Base64), Compression.Deflate)), let _t = ((type nullable text) meta [Serialized.Text = true]) in type table [RawText = _t]),

    // sugar. minimal snippet to preview nested values as text. ex: nested lists
    Xray = (source as any, optional options as nullable record) as text => [
        options = Record.Combine({defaults, (options ?? []) }),
        defaults = [ WrapText = true, Encoding = TextEncoding.Utf8 ],
        bytes = Json.FromValue(source),
        string = Text.FromBinary( bytes, options[Encoding] ),
        wrapLines = Text.Replace( string, ",", ",#(cr,lf)"),
        ret = if options[WrapText] then wrapLines else string
    ][ret],

    // values like "10s" or "3m"
    Splitter.SplitDigitWithSuffix = // Splitter.SplitTextByDigitWithSuffixTransition =
        Splitter.SplitTextByCharacterTransition(
        {"0".."9"}, (c) => not List.Contains({"0".."9"}, c) ),

    // sugar to make it easier to embed powerquery as a string literal
    DocExpand = (source as text) =>
        Text.Replace( source, "␞", "#(0022)" ),

    Duration.FromCustom.Type = type function (
        source as duration
    ) as duration meta [
        Documentation.Name = "Duration.FromCustom",
        Documentation.LongDescription = Text.Combine({
            "Call <code>Splitter.SplitDigitWithSuffix()</code>.","",
            "Pick out pairs of 'd', 'h', 'm', 's' and 'd' using <code>List.SelectBySuffix()</code>",
            "returns type <code>duration</code>"
        }, "<br>")
    ],
    Duration.FromCustom.Func = (source as text) as duration => [
        clean = Text.Trim( Text.Lower( source, Culture.Current ) ),
        s_segs = Text.Split(clean, " "),
        s_pairs = List.Transform( s_segs, (pair) => Splitter.SplitDigitWithSuffix( pair )),

        Days =
            Number.From( List.SelectBySuffix( s_pairs, "d" ) ) ?? 0,
        Hours =
            Number.From( List.SelectBySuffix( s_pairs, "h" ) ) ?? 0,
        Minutes =
            Number.From( List.SelectBySuffix( s_pairs, "m" ) ) ?? 0,
        Seconds =
            Number.From( List.SelectBySuffix( s_pairs, "s" ) ) ?? 0,

        inst =
             #duration( Days, Hours, Minutes, Seconds )
    ][inst],
    Duration.FromCustom = Value.ReplaceType( Duration.FromCustom.Func, Duration.FromCustom.Type),


   // expects a list of pairs of 2 elements, first is the digit, 2nd is the unit
    List.SelectBySuffix.Func = ( items as list, unit as text ) as any =>
        List.First(
            List.Select( items,
                (i) => i{1} = unit ), null ){0}?,

    List.SelectBySuffix.Type = type function (
        items as (type { text }),
        unit as text
    ) as text meta [
        Documentation.Name = "List.SelectBySuffix",
        Documentation.LongDescription = Text.Combine({
            "After calling <code>Splitter.SplitDigitWithSuffix()</code>, this function will choose one item from the pair", "", "#(tab)<b>Example</b>:  For the text <code>'2m 3s'</code> find <code>'2'<code> if unit is <code>'m'<code>"
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

    x1 = Xray( Source ) ,
    #"Changed Type" = Table.TransformColumnTypes(Source,{{"RawText", type text}}),
    #"Added Custom" = Table.AddColumn(#"Changed Type", "Coerce", each Duration.FromCustom( [RawText] ), Duration.Type )
in
    #"Added Custom"