//
let
    Letters = {"a".."z"},
    Str = [ Null = "␀" ],
    SeeMoreAt = "https://github.com/ninmonkey/ninMonkQuery-examples", //  Jake Bolton, 2023-05
    // quick function to csv-ify a list, if possible.
    // did you know let expressions are actually
    // sugar for record expressions? for example
    ToCsv = (source as list) as text => [
        items = List.Transform(
            source,
            (item) =>
                try Text.From(item)
                catch (e) => Str[Null]
        ),
        join = "{ " & Text.Combine(items, ", " ) & " }"
    ][join],

    // another way to preview, if the default conversion is good enough
    ToJson = (source as any) as any =>
        let
            bytes = Json.FromValue(source),
            lines = Text.FromBinary( bytes, TextEncoding.Utf8 )
        in
            lines,

    numChars = List.Count(Letters),
    tests = {
        [ Start = 0, Count = null ],
        [ Start = 0, Count = 3 ],
        [ Start = 3, Count = 4 ],
        [ Start = 8, Count = null ],
        [ Start = 8, Count = 9999 ],
        [ Start = numChars -3, Count = null ]
    },
    test_table = tests,
    Summary = [
        Letters = Letters,
        tests = tests
    ],
    tests1 = Summary[tests],
    #"Converted to Table" = Table.FromList(tests1, Splitter.SplitByNothing(), null, null, ExtraValues.Error)

in
    #"Converted to Table"
