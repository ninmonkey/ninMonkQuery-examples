    let
        Splitter.ScriptExtent = Splitter.SplitTextByEachDelimiter({"[", ",", "-", ",", "]"}, QuoteStyle.None),

        Summary = [
            raw_text    = "[117,5-117,17]",
            segments    = Splitter.ScriptExtent(raw_text),
            startLine   = segments{1}?,
            startColumn = segments{2}?,
            endLine     = segments{3}?,
            endCol      = segments{4}?
        ]
    in
        Summary
