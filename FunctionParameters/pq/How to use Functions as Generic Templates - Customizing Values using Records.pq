let

/*
    function that composes your default settings with any options
*/

/* fancy arguments by composing records */

    // wip, not done

    FormatPerson = ( source as any, optional options as nullable record ) as any => [
        defaults = [
            Encoding = TextEncoding.Utf8,
            Species = "cat", Id = 0, Culture = "en-us" ],

        config = Record.Combine({
            defaults,
            options ?? []
        }),

        json = Json.FromValue( source, config[Encoding] ),
        str = Text.FromBinary( json, config[Encoding] ),
        renderNumber = Number.ToText( 123456789, [ Culture = "de-de", Format = "n" ]),

        template = Text.Combine(
            {
                "Original Value: #[before]",
                "Formatted: #[after]",
                "Using config: #[config]"
            },
            "#(cr,lf)"
        ),
        mergedText = Text.Format(
            // template,
            "#[before], #[after]",
            [
                    before = source,
                    after = renderNumber,
                    config =  config
            ],
            config[Culture]
        ),

        return =  renderNumber

    ][return],

    items = {
        [ Species = "cat", Id = 0 ],
        [ Species = "Human", Region = "East" ],
        [ Culture = "de-de" ]

    },
    applyEach = List.Transform( items, (row) => FormatPerson( row ) ),
    #"Converted to Table" = Table.FromList(applyEach, Splitter.SplitByNothing(), type table [ JsonText = text ], null, ExtraValues.Error)
in
    #"Converted to Table"