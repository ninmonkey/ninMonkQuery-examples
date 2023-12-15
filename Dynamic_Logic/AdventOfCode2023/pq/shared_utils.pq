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
    ][json]
]