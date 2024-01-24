let
    // from: <https://github.com/ninmonkey/ninMonkQuery-examples/tree/main/forumQuestions/pq>
    Source = Table.FromRecords({
        [ DateString = "Mar 2003", Data = 103],
        [ DateString = "Mar 2003", Data = 16 ],
        [ DateString = "Feb 2003", Data = 8  ],
        [ DateString = "Feb 2003", Data = 512],
        [ DateString = "Jan 2003", Data = 64 ],
        [ DateString = "Jan 2003", Data = 32 ]
    }),

    /*
        "culture" argument combined with "date" type

        automatically converts "mar 2003" to #date(2023, 3, 1)

    */
    ConvertDates = Table.TransformColumnTypes( Source,
        {{"DateString", type date}}, "en-us")
in
    ConvertDates