let
    /*
    original: <https://github.com/ninmonkey/ninMonkQuery-examples/blob/ce4979d0c21af3cbc27d5c36d10c502a256bdc49/Types/pq/DeclaringNestedTypes-ListsAsIntegers.pq#L0-L1>
    About:
        showing correct and incorrect types
        Ddo functions enforce nested types, or just the top level ?

        Example Passing a list of text, then a list of numbers
    */
    Csv = (items as list) as any => [
        joinedText = Text.Combine( items, ", " ),
        assertFirstList =
            if items{0} is text
            then joinedText
            else error [
                Message.Format = "Expects first value to be text! Actual: #{0} for item: #{1}",
                Message.Parameters = { Value.Type( items{0} ), items{0} }
            ],
        return = assertFirstList
    ][return],


    Summary = [
        StrList   = {"hi", "world", "42" },
        MixedList = { 42, "hi", "world" },
        Csv1      = Csv( StrList ),
        Csv2      = Csv( MixedList )

    ],
    Csv2 = Summary
in
    Csv2