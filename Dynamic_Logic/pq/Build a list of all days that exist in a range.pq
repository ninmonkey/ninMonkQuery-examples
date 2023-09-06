let 
        date1   = #date(2021, 1, 1), 
        date2   = #date(2021, 2, 21),
        // this will return a list of every day in the range, including end points
        // it doesn't matter which order you pass the dates in
        GenerateAllDays = ( source as list ) as list => 
            let
                start = List.Min( source ),
                end = List.Max( source ),
                days = { Number.From(start)..Number.From(end) },
                asDates = List.Transform( days, (item) => Date.From(item) )
            in 
                asDates,
                
        fin = GenerateAllDays( { date1, date2 } )
    in
        fin