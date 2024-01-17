[
    Default.Module.Culture = "en-us",
    Default.Culture = ( culture as nullable text ) as text =>
        Default( culture, Default.Module.Culture ),

    Default = ( value as any, default as nullable any ) as any => [
        ret = value ?? default ?? null
    ][ret],
    // returns .
    As.TextList = (source as list, optional culture as nullable text) as list => [
        // Culture = culture ?? Default.Culture,
        Culture = Default.Culture( culture ),
        items = List.Transform( source, each Text.From(_, Culture ) ),
        returnType = type { text },
        ret = Value.ReplaceType( items, returnType )
    ][ret],

    Join.Csv = (source as any, optional options as nullable record) as text => [
        Culture = options[Culture]? ?? Default.Culture,
        Separator = options[Sperator]? ?? ", ",
        ret = Text.Combine( As.TextList( source, Default.Culture ), Separator )
    ][ret]
]