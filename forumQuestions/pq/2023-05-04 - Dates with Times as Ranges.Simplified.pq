let
    // This is a simplified version of the fancy pants version at: "2023-05-04 - Dates with Times as Ranges.pq"
    DateTimeRange.FromText = (source as text, optional config as nullable record)
        as record => let
            // default values, optionally overrided by user, key-by-key
            config = Record.Combine({
                [
                    Format = "d/MM/yyyy",
                    Culture = Culture.Current // or maybe "en-us", "de-de", "es-us"
                ],
                config ?? []
            }),
            date_str  = Text.BeforeDelimiter( source, " ", Occurrence.First ),
            times_str = Text.AfterDelimiter( source, " ", Occurrence.First ),
            pair_str  = Text.Split( times_str, " - " ),
            start     = Time.FromText( pair_str{0}, [ Culture = config[Culture] ] ),
            end       = Time.FromText( pair_str{1}, [ Culture = config[Culture] ] ),
            Date      = Date.FromText( date_str, [ Format = config[Format], Culture = config[Culture] ]),
            return    = [
                Date  = Date,
                StartTime = start,
                EndTime = end
            ]
        in return,

    Summary = [
        test1 = DateTimeRange.FromText("9/11/2022 9:00 AM - 12:00 PM"),
        expected = [
            Date        = #date(2022, 11, 9),
            StartTime   = Time.FromText("9:00 AM",  [Culture = "en-us"] ),
            EndTime     = Time.FromText("12:00 PM", [Culture = "en-us"] )
        ],
        Actual = test1 = expected
    ]
in
    Summary