let 
    text_list = {"hi", "world"},
    Text.Csv = (source as list) as text =>
        let 
            // note, this is declaring a new variable, of the same name
            // in this "function scope"
            text_list = List.Transform( source, each Text.From(_) ),
            render = Text.Combine( text_list,  ", " )
        in 
            render,        
        
    // now the inner "text_list" went "out of scope",
    // text_list is now the original value

    // or alias it
    List.ToCsv = Text.Csv,

    Stuff = {0..10} & {"z".."e"},

    Summary = [
        Stuff = Text.Csv( Stuff ),
        Nums = Text.Csv({0..10}),
        When = Text.Csv({
            #date(2023,1,1),
            DateTime.LocalNow()
        }),
        Aliased = List.ToCsv({23, "dsf"})
    ]
in Summary
