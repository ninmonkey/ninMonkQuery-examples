let
    Source = #table(
        type table[DateText = text],
        {
            { "13/11/2022 10:00 AM - 6:00 PM" },
            { "9/11/2022 9:00 AM - 12:00 PM" }
        }),

    DateTimeRange.FromText = Value.ReplaceType( DateTimeRange.FromText.Func, DateTimeRange.FromText.Type ),
    DateTimeRange.FromText.Type = type function(
        source as text,
        optional options as nullable record
    ) as record meta [
        Documentation.Name = "DateTimeRange.FromText",
        Documentation.Author = "Jake Bolton <jake.bolton.314@gmail.com>",
        Documentation.Author.Github = "https://github.com/ninmonkey",
        Documentation.Author.Blog = "https://ninmonkeys.com/blog/",
        Documentation.Author.SourceUrl = "https://github.com/ninmonkey/ninMonkQuery-examples",
        Documentation.LongDescription = Text.Combine({
            "Transforms text that contains a Date and Time range into a date and time data-types",
            "",
            "Supports ranges like: ""13/11/2022 10:00 AM - 6:00 PM""",
            "",
            "<b>## Docs, References, or Tutorials:</b>",
            "",
            "- UI on splitting: <https://learn.microsoft.com/en-us/power-query/split-columns-delimiter>",
            "- Splitter functions: <https://learn.microsoft.com/en-us/powerquery-m/splitter-functions>",
            "- See sections on extraction and transformation: <https://learn.microsoft.com/en-us/powerquery-m/text-functions#extraction>",
            "- <https://github.com/ninmonkey/ninMonkQuery-examples> has more examples.",
            "",

            "<b>## This function was written to demonstratates a few concepts:</b>",
            "",
            "• Using custom <b>format string</b>s for Date.FromText and Time.FromText",
            "• Parsing text is simpler if you break it into two steps. Then you can use really simple delimiters that you split around.",
            "• Using a custom <b>Culture</b> which controls the rules for converting to and from text",
            "• Adding documentation to your functions",
            "• Using HTML in your documentation",
            "• Long texts are easier to read if you use <code>Text.Combine()</code> with &lt;br&gt; in HTML and newlines for text",
            "• Totally <b>optional</b> parameter",
            "• How to <b>shadow</b> variables in the local scope, overriding the outer scope",
            "• Using a Record for Default Values",
            "• Combining the default Record allowing you to overwrite some of the defaults, basically opt-in to changing some without losing all the defaults"

        }, "<br>"),
            Documentation.Examples = {
                // [Description = "Inspecting strings", Code = "Text.Inspect(""SomeString"")", Result = "..."],
                [Description = "Inspecting table columns",

                Code = Text.Combine({
                    "let",
                    "   sample = ""13/11/2022 10:00 AM - 6:00 PM""",
                    "   in sample"
                    }, "#(cr,lf)"),
                Result = "..."]
            }

    ],
    DateTimeRange.FromText.Func =
        (source as text, optional config as nullable record)
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
        Source = Source,
        target = Source{1}[DateText],
        test = DateTimeRange.FromText( target ),
        expected = [
            Date = #date(2022, 11, 9),
            StartTime = Time.FromText("9:00 AM", [Culture = "en-us"]),
            EndTime = Time.FromText("12:00 PM", [Culture = "en-us"])
        ],
        DateTimeRange.FromText = DateTimeRange.FromText,
        #"Conversion Is Correct?" = expected = test,
        #"Inspect Custom Function Metadata" = Value.Metadata( Value.Type( DateTimeRange.FromText ) )
    ]
in
    Summary