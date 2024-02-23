
let
    // you may override one or more options, individually or all at once
    Text.Join = ( items as list, optional options as nullable record) as text =>
        let
            items  = List.Transform( items, each Text.From(_) ),
            defaultOptions = [
                Separator = ", ",
                Prefix    = "",
                Suffix    = ""
            ],
            config = Record.Combine( {
                defaultOptions,
                options ?? []
            }),
            joined = Text.Combine( items, config[Separator] ),
            return = Text.Combine({
                config[Prefix],
                joined,
                config[Suffix]
            }, "")
        in
            return,


    /*
    kind of silly, just call:

        Text.Join( items, [Separator = "," ] )
    */
    Csv = (items as list, optional options as nullable record) as text =>
        let return = Text.Join( items, config ),
            config = Record.Combine({
                options,
                [ Separator = ", " ]
            })
        in  return,


    Summary = [
        alpha = {"a".."z"},

        tryCsv = Text.Join( alpha, [Separator = "," ] ),

        tryBullets = Text.Join( alpha, [
            Separator = "#(cr,lf) • ",
            Prefix    = "#(cr,lf) • "
        ])
    ]
in
    Summary

/*
            itemsSafer = List.Transform( items,
                each
                          try Text.From(_)
                    catch (e) => e[Message]
            ),
            */