let

    /*
        shows signatures, without lib showing up in the UI
    */
    Nums = {0..5}, Alpha = {"a".."f"},

    example   = lib[Csv]( Nums ),
    FinalStep = lib[Csv]( Nums, [ Prefix = "< " ]  ),

    lib = [
        // function1
        Csv = (
            items as list,
            optional options as nullable record
        ) as text =>
            let
                prefix = options[Prefix]? ?? "[ ",
                suffix = options[Suffix]? ?? " ]",
                textList = List.Transform(items, each Text.From(_) ),
                return = prefix & Text.Combine( textList, ", " ) & suffix
            in return,

        // function 2
        FmtArray = (items as list) as text =>
            "[ " & Csv(items) & " ]"

    ]
in
    FinalStep