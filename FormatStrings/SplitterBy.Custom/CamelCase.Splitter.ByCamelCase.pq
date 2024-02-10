[
    SplitBy.UpperToLower = Splitter.SplitTextByCharacterTransition(
        {"A".."Z"}, {"a".."z"}),

    SplitBy.LowerToUpper = Splitter.SplitTextByCharacterTransition(
        {"a".."z"}, {"A".."Z"}),

    SplitBy.SpaceToAlpha =  Splitter.SplitTextByCharacterTransition(
            {" "}, {"a".."z"} & {"A".."Z"} ),

    SplitBy.ToAlphaToSpace =  Splitter.SplitTextByCharacterTransition(
            {"a".."z"} & {"A".."Z"} , {" "} ),



    Summary = [
        s1 = SplitBy.LowerToUpper( "CamelCase" ),    // { "Camel", "Case" }
        s2 = SplitBy.LowerToUpper( "seaCamelCase" ), // { "sea", "Camel", "Case" }


        lines = "hi world #(cr,lf)#(cr,lf) cat#(tab)1234 ",
        l1 = SplitBy.SpaceToAlpha( lines ) // { "hi", "world", "cat 1234"},

    ]
]