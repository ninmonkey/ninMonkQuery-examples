let
    // ignore this step, it's just "enter-data" which is JSON
    Source = Table.FromRows(Json.Document(Binary.Decompress(Binary.FromText("i45WSspPUtJRyi9KzEtPVUjKKU0F8hKVYnWilbJS84DsotQUIJmkFBsLAA==", BinaryEncoding.Base64), Compression.Deflate)), let _t = ((type nullable text) meta [Serialized.Text = true]) in type table [#"   User  " = _t, #"    Color " = _t, #" has Newline  #(lf)#(lf)" = _t]),

    /*
    Visualize which exact characters exist in your header. these are codepoints as hex.
    Input:  "    Color "
    Output: "Hex: 20, 20, 20, 20, 43, 6f, 6c, 6f, 72, 20"
    */
    InspectInvisibleText = ( columnNames as list ) =>
        let return =
            List.Transform( columnNames, ( curName ) =>  [
                HasOuterWhitespace = RawName <> Text.Trim( Text.Clean( curName ) ),
                RawName = curName,

                Symbols = Text.FormatControlSymbols( curName ),
                HexSummary = "Hex: " & Text.Combine( AsHexStr, ", " ),
                DecSummary = "Dec: " & Text.Combine( List.Transform( Codepoints, each Text.From(_)), ", " ),

                CharList   = Text.ToList( RawName ),
                Codepoints = List.Transform( CharList, each Character.ToNumber( _ ) ),
                AsHexStr   = List.Transform( Codepoints, each Number.ToText( _, "x" ) )
            ] )
        in  return,

    /*
    techincal note:
        If you know c#, `Text.ToList` is technically returning a `char[]`, not a `System.Text.Rune[]`
        If you're curious, there's a pretty decent technical summary of the differences here:

        - Character encoding in dotnet: https://learn.microsoft.com/en-us/dotnet/standard/base-types/character-encoding-introduction
        - What character is a hex codepoint, like 20?: https://www.compart.com/en/unicode/U+0020
        - To see all ascii characters on one page: https://www.compart.com/en/unicode/block/U+0000
            That shows the first 128 characters:
                is 0-127 in decimal
                or 0x0-0x7f in hexadecimal
    */

    /*
    input: text with whitespace
    output: text with whitespace visualized
    Techincally this isn't codepoints, so it's not perfect, but works for all of ascii

    probably poor performance
    */
    Text.FormatControlSymbols = (string as text) as text =>
        let
            CharList   = Text.ToList( string ),
            Symbols = List.Transform(
                CharList,
                (char) => [
                    codepoint = Character.ToNumber( char ),
                    newChar =
                        if codepoint <= 0x20
                        then Character.FromNumber( codepoint + 0x2400 )
                        else if codepoint = 0x200d then "<ZWJ>"
                        else char
                ][newChar]
            ),

            return = Text.Combine( Symbols, "" )

        in  return,


    raw_names = Table.ColumnNames( Source ),
    raw_names_extra =  {
        "  User#(cr,lf) Names",
        "  Has#(tab) tabs   ",
        "#(0020) Zero-Width #(200d) Joiner Inside",
        Character.FromNumber(0x1b),
        "Escape #(001b) Sequence"
    },

    inspected_columns = InspectInvisibleText( raw_names ),      // from enter-data
    inspected         = InspectInvisibleText( raw_names_extra ),// inline strings for even more special chars

    // You can use codepoints in strings using the hex notation
    ExampleCodepointsInPQ = [
        RawStr   = " ",
        AsInline = "#(0020)",
        AsCodepoint = Character.FromNumber( 32 ),
        AsCodepointFromHex = Character.FromNumber( 0x20 ),

        // test that shows they builds the exactly identical string:
        AreExactlyEqual =
            1 = List.Count( List.Distinct(
                    { RawStr, AsInline, AsCodepoint, AsCodepointFromHex }, Comparer.Ordinal
            ) )
    ],

    Summary = Table.FromRecords( inspected )
in
    Summary