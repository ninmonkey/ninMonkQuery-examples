    let
        // original question: <https://www.reddit.com/r/PowerBI/comments/19elwg3/more_efficient_way_to_do_this_in_power_query/>
        Source = Table.FromRecords({
            [ DateString = "Mar 2003", Data = 103],
            [ DateString = "Mar 2003", Data = 16 ],
            [ DateString = "Feb 2003", Data = 8  ],
            [ DateString = "Feb 2003", Data = 512],
            [ DateString = "Jan 2003", Data = 64 ],
            [ DateString = "Jan 2003", Data = 32 ]
        }),

        oldestDate  = #date(2003, 2, 1),
        datesBefore = #date(2003, 3, 1),

        // "culture" argument combined with "date" type
        // automatically converts "mar 2003" to #date(2023, 3, 1)
        ConvertDates = Table.TransformColumnTypes( Source,
            {{"DateString", type date}}, "en-us"),

        Renamed = Table.RenameColumns( ConvertDates, {{ "DateString", "Date"}}),

        DropMonths = Table.SelectRows( Renamed, each [Date] >= oldestDate and [Date] < datesBefore )

        // if you require group or distinct, try it after the above
    in
        DropMonths