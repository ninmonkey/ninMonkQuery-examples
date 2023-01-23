let

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
        in t
in
    Text.Inspect