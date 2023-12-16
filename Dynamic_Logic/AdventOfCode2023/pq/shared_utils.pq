[
    About = "shared helper functions",
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