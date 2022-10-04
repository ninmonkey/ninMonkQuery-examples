let
    d1 = #date(2022, 3, 9),
    d2 = #date(2003, 11, 20),

    coerceDates = ( source as text ) as nullable date =>
        // usage: see the last 2 query steps
        let
            maybeDate1 =
                try Date.FromText(
                    source, [Culture = "en-us", Format= fStr1 ])
                catch () => null,
                // normally you could preserve error info

            maybeDate2 =
                try Date.FromText(
                    source, [Culture = "en-us", Format= fStr2 ])
                catch () => null
        in
            maybeDate1 ?? maybeDate2,
            // or another way, for n-number of tests
            // List.First( List.RemoveNulls({ maybeDate1, maybeDate2}) ),

    fStr1 = "ddd-MM-dd-yyyy",
    fStr2 = "ddd-MMMM-dd-yyyy",
    dateStr1 = Date.ToText( d1, [ Culture = "en-us", Format = fStr1 ] ),
    dateStr2 = Date.ToText( d2, [ Culture = "en-us", Format = fStr2 ] ),
    table_rows = { dateStr1, dateStr2 },

    Source = Table.FromList(
        table_rows, Splitter.SplitByNothing(),
        type table [ RawText = text ], null, ExtraValues.Error),

    #"Using AddColumn" = Table.AddColumn(
        Source, "Dynamic Dates", each coerceDates( [RawText] ) , type date ),

    #"Dynamic Date Transform" = Table.TransformColumns(
        #"Using AddColumn", { { "RawText", coerceDates, type date } } )
in
    #"Dynamic Date Transform"