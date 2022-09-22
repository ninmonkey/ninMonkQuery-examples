let
    Text.ReplacePartialMatches = Value.ReplaceType( Text.ReplacePartialMatches_impl, Text.ReplacePartialMatches.Type ),
    Text.ReplacePartialMatches.Type = type function(
        source as text,
        mapping as Table.Type
    ) as text meta [
        Documentation.Name = "Text.ReplacePartialMatches",
        Documentation.LongDescription = Text.Combine({
            "Test strings for partial text matches. Replace the entire cell/value with the new replacement text.",
            "",
            "Mapping table requires two columns: <code>[Partial]</code> and <code>[New Value]</code> "

        }, "<br>")
    ],

    Text.ReplacePartialMatches_impl = ( source as text, mapping as table ) as text =>
        // todo: performance, end on very first replacement
        let
            mappingList = Table.ToRecords( mapping ),
            result = List.Accumulate(
                mappingList,
                source,
                (state, cur) =>
                    if Text.Contains( state, cur[Partial], Comparer.OrdinalIgnoreCase )
                    then cur[New Value] else state
            )
        in result

in
    Text.ReplacePartialMatches