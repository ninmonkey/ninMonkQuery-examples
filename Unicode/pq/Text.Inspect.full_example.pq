let
    Source = Unicode,
    Samples2 = {
        "#(0000)ca#(cr,lf)t",
        "Hi#(2400)world#(2401)",
        List.Transform( { 0x2400..(0x2400+100) }, each Character.FromNumber(_) ),
        "family : #(0001f46a)",
        "#(0001f46a)",
        "family+: #(0001f469)#(0000200d)#(0001f469)#(0000200d)#(0001f467)"
    },
        items = {
        [ Name = "Cat",        Rune = "#(0001f408)" ],
        [ Name = "Dog",        Rune = "#(0001f415)" ],
        [ Name = "Snake",      Rune = "#(0001f40d)" ],
        [ Name = "Frog",       Rune = "#(0001f438)" ],
        [ Name = "Turtle",     Rune = "#(0001f422)" ],
        [ Name = "CR",         Rune = "#(cr)" ],
        [ Name = "CR Symbol",  Rune = "#(240d)" ],
        [ Name = "NL",         Rune = "#(lf)" ],
        [ Name = "NL Symbol",  Rune = "#(240a)" ],
        [ Name = "CRNL",       Rune = "#(cr,lf)" ],
        [ Name = "CRNL Symbol",Rune = "#(240d,240a)" ],
        [ Name = "Null Symbol",Rune = "#(2400)" ],
        [ Name = "Zebra",      Rune = Character.FromNumber( 0x1f993) ],
        [ Name = "Confused",   Rune = "#(0001f635)" ]
    },

    ToCsv = Value.ReplaceType( ToCsv.Impl, ToCsv.Type ),
    ToCsv.Type = type function (
        source as list
    ) as text meta [
        Documentation.Name = "ToCsv",
        Documentation.LongDescription = Text.Combine({
            "Converts a list of anything, into a csv deliminated list"
        }, "<br>")
    ],
    ToCsv.Impl = ( source as list ) as text =>
        let text_list = List.Transform(
            source,
            (item) =>
                try Text.From(item, "en-us")
                catch (e) => "#(2400)" ),

            render = Text.Combine(text_list, ", " )
        in  render,

    Text.Inspect = Value.ReplaceType( Text.Inspect.impl, Text.Inspect.Type ),
    Text.Inspect.Type = type function (
        source as text
    ) as table meta [
        Documentation.Name = "Text.Inspect",
        Documentation.LongDescription = Text.Combine({
            "Returns a table of [ Rune, Codepoint ] pairs.",
            "",
            "Note that this is the equivalent of [String]::ToCharArray(), not [String]::EnumerateRunes()",
            "",
            "Meaning each item is <b>a [char]</b> (2bytes in dotnet), some codepoints will <b>become split</b>",
            "Breaking because it's not <b>truely enumerating the codepoints</b> in a string.",
            "AFAIK currently there's no built-in method to get [Text.Rune] enumerator without calculations",
            ""
            },"<br>"),
        Documentation.Examples = {
            [Description = "Inspecting strings", Code = "Text.Inspect(""SomeString"")", Result = "..."],
            [Description = "Inspecting table columns",
            Code = Text.Combine({
                "let",
                "   InspectResults.Schema  = type table [",
                "       Rune = text, Codepoint = Int64.Type ],",
                "",
                "   inspect_col = Table.AddColumn( Source, ""Inspect Name"",",
                "       (row) => Text.Inspect( row[Name] ), InspectResults.Schema )",
                "   in inspect_col"
                }, "#(cr,lf)"),
            Result = "..."]
        }
    ],
    Text.Inspect.impl = (source as text) as table =>
        let charList = List.Transform(
                    Text.ToList(source), (char) => [
                        Rune = char, Codepoint = Character.ToNumber(char)
                    ]),
                t = Table.FromRecords(charList, type table[
                    Rune = Character.Type,
                    Codepoint = Int64.Type
                ], MissingField.Error)
        in t,


    try1 = Text.Inspect( List.Last( Samples2 ) ),

    InspectResults.Schema  = type table [
        Rune = text, Codepoint = Int64.Type ],
    example1 = Table.AddColumn( Source, "Inspect Name", (row) => Text.Inspect( row[Name] ), InspectResults.Schema ),
    example2 = Table.AddColumn( example1, "Summarize Name",
        (row) =>
            ToCsv( row[Inspect Name][Codepoint] ), type text),
    fin = [
        Text.Inspect = Text.Inspect,
        Source = Source, Source2 = Samples2, items = items,
        Example1 = example1, Example2 = example2
    ],
    Example2 = fin[Example2]
in
    Example2