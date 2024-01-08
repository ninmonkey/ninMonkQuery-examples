[
    About = "ninlib 2024.01 | helper functions",
    ToCollect = {
        [ What = "Assert.ColumnsExist" ],
        [ What = "AssertConditions" ]
        /*
        [1]
        / returns first+last merged, as one number
            Text.FindFirstLastDigits = ( source as text ) as number => [
                first = Text.PositionOfAny( source, digits, Occurrence.First ),
                last = Text.PositionOfAny( source, digits, Occurrence.Last ), chars = Text.ToList(source),
                textNumber = chars{first} & chars{last},
                return = Number.FromText( textNumber, null )
            ][return],
        [2]
            let
                    SketchBuffer = let
                    curFilename = "sketchbuffer.pq",
                    fullPath = Text.Combine({ #"Pq Folder", curFilename }, "\")
                in
                    EvalQuery( fullPath ),
                    q0000 = Table.FromRecords( SketchBuffer[q0000] )
                in
                    q0000
        [3]
            // EvalQuery
                let
                // evaluates a .pq text file that's editable outside of power bi, without pasting updates. just refresh.
                EvalQueryFunc = (filePath as text, optional options as nullable record) as any => [
                    encoding = options[Encoding]? ?? TextEncoding.Utf8,
                    environment = options[Environment]? ?? #shared,
                    bytes = File.Contents(filePath),
                    lines = Text.FromBinary( bytes, encoding ),
                    return = Expression.Evaluate( lines, environment )
                ][return]
            in
                EvalQueryFunc

            // EvalQuery
                    let
                    // evaluates a .pq text file that's editable outside of power bi, without pasting updates. just refresh.
                    EvalQueryFunc = (filePath as text, optional options as nullable record) as any => [
                        encoding = options[Encoding]? ?? TextEncoding.Utf8,
                        environment = options[Environment]? ?? #shared,
                        bytes = File.Contents(filePath),
                        lines = Text.FromBinary( bytes, encoding ),
                        return = Expression.Evaluate( lines, environment )
                    ][return]
                in
                    EvalQueryFunc

                // SharedUtils_Path
                "H:\data\2023\BI\git\ninMonkQuery-examples\Dynamic_Logic\AdventOfCode2023\pq\shared_utils.pq" meta [IsParameterQuery=true, List={"H:\data\2023\BI\git\ninMonkQuery-examples\Dynamic_Logic\AdventOfCode2023\pq\shared_utils.pq"}, DefaultValue="H:\data\2023\BI\git\ninMonkQuery-examples\Dynamic_Logic\AdventOfCode2023\pq\shared_utils.pq", Type="Text", IsParameterQueryRequired=true]

                // lib
                let
                    Source = EvalQuery( SharedUtils_Path )
                in
                    Source

        */
    },
    Text.ContainsCI = (source as text, substring as text) as logical =>
        Text.Contains( source, substring, Comparer.OrdinalIgnoreCase ),

    Csv = (source as list) as text => [
        segments = List.Transform( source, each Text.From(_) ),
        return = Text.Combine( segments, ", " )
    ][return],

    XRay = (source as any) as text => [
        bytes = Json.FromValue( source, TextEncoding.Utf8 ),
        json = Text.FromBinary( bytes, TextEncoding.Utf8 )
    ][json],

    // Like Text.Replace except that this replaces at most one single occurrence of oldValue
    Text.ReplaceFirstOnly = (source as nullable text, oldValue as text, newValue as text) as nullable text => [
        found = Text.PositionOf( source, oldValue, Occurrence.First, Comparer.OrdinalIgnoreCase ),
        replaced = Text.ReplaceRange( source, found, Text.Length( oldValue ), newValue ),
        return =
            if source = null then null
            else if found = -1 then source
            else replaced
    ][return],

    Text.PositionOf.CI = (source as text, substring as text, optional options as nullable record) as any => [
            occurrence = options[Occurrence]? ?? Occurrence.First,
            comparer = options[Comparer]? ?? Comparer.OrdinalIgnoreCase,
            ret = Text.PositionOf( source, substring, occurrence, comparer )
        ][ret]
]